// 从相邻 bynd-app 的人体模型生成 600px 矢量帧；该脚本仅写入指定临时目录。
// 用法：node tool/export_anatomy_frames.mjs <bynd-app目录> <帧输出目录> <sharp模块路径> [动作ID]
import { writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { createRequire } from 'node:module';
import { resolve, join } from 'node:path';
import { pathToFileURL } from 'node:url';
const [sourceArg, outputArg, sharpArg, onlyId] = process.argv.slice(2);
if (!sourceArg || !outputArg || !sharpArg) throw new Error('请提供 bynd-app 目录、输出目录和 sharp 模块路径');
const source = resolve(sourceArg);
const temp = resolve(outputArg);
const { ANATOMIA } = await import(pathToFileURL(join(source, 'src/animacoes/anatomia/index.js')).href);
const { criaAnatomia, legendaDe } = await import(pathToFileURL(join(source, 'src/animacoes/anatomia/motor.js')).href);
const require = createRequire(import.meta.url);
const sharp = require(resolve(sharpArg));
const esc = s => String(s).replaceAll('&','&amp;').replaceAll('"','&quot;').replaceAll('<','&lt;');
class Elem {
 constructor(tag) { this.tag=tag; this.attrs={}; this.children=[]; this.parent=null; this.raw=''; this.map={}; }
 setAttribute(k,v) { this.attrs[k]=String(v); }
 appendChild(el) { if(el.parent){const i=el.parent.children.indexOf(el); if(i>=0) el.parent.children.splice(i,1);} el.parent=this;this.children.push(el);return el; }
 set innerHTML(v){this.raw=v;this.children=[];this.map={};}
 get innerHTML(){return this.raw;}
 querySelector(selector){const id=selector.slice(1);return this.map[id]??=(new Elem('placeholder'));}
 serialize(){let raw=this.raw;for(const [id,element] of Object.entries(this.map)) {const re=new RegExp('(<[\\w:-]+\\s+id="'+id+'")([^>]*?)(/?>)');raw=raw.replace(re,(_,a,b,c)=>a+b+Object.entries(element.attrs).map(([k,v])=>' '+k+'="'+esc(v)+'"').join('')+c);}
 return '<'+this.tag+Object.entries(this.attrs).map(([k,v])=>' '+k+'="'+esc(v)+'"').join('')+'>'+raw+this.children.map(c=>c.serialize()).join('')+'</'+this.tag+'>';}
}
globalThis.document={createElementNS:(_,tag)=>new Elem(tag), addEventListener(){},removeEventListener(){},hidden:true};globalThis.CSS={escape:s=>s};globalThis.matchMedia=()=>({matches:true,addEventListener(){},removeEventListener(){}});globalThis.requestAnimationFrame=()=>0;globalThis.cancelAnimationFrame=()=>{};
mkdirSync(temp,{recursive:true});
const manifest=[];
sharp.concurrency(1);
for (const [id,ex] of Object.entries(ANATOMIA).filter(([id]) => !onlyId || id === onlyId)) {
 if (!/^[a-z0-9-]+$/.test(id)) throw Error('invalid exercise id: '+id);
 if (!Array.from({length:25},(_,i)=>existsSync(`${temp}/${id}-${i}.png`)).every(Boolean)) {
  const svg=new Elem('svg');svg.setAttribute('xmlns','http://www.w3.org/2000/svg');
  const m=criaAnatomia(svg,ex,{semFundo:true,uid:'a'});
  let batch=[];
  for (let i=0;i<25;i++) {
   m.desenha(i===0 ? (ex.pose??ex.duracao/2) : ex.duracao*(i-1)/24);
   const bytes=Buffer.from(svg.serialize());
   batch.push(sharp(bytes).resize({width:600}).png({compressionLevel:1}).toFile(`${temp}/${id}-${i}.png`));
   if (batch.length === 3) { await Promise.all(batch); batch=[]; }
  }
  await Promise.all(batch);
 }
 manifest.push({id,duration:ex.duracao,legend:legendaDe(ex)});
}
if (manifest.length === 0) throw new Error(`未找到动作：${onlyId}`);
writeFileSync(`${temp}/manifest.json`,JSON.stringify(manifest));
console.log('exported',manifest.length,'exercises');
