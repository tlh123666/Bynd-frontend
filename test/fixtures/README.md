# ATLAS 接口响应快照

这三个文件是 dev 环境（`api.byndhealth.com.br`）的**真实**响应，2026-11-08 采集，
用作 DTO 解析的契约测试输入。

```text
workspace.json     GET /api/v1/me/ai/workspace?timezone=America/Sao_Paulo&locale=pt-BR
capabilities.json  GET /api/v1/me/ai/capabilities
insights.json      GET /api/v1/me/insights?timezone=America/Sao_Paulo&locale=pt-BR&limit=5
```

## 为什么用真实响应而不是手写样例

手写的样例总是恰好长得跟模型一致，而真实响应会带上这些只有上线才知道的东西：

- `omitempty` 字段真的不出现（`trainingReadiness.score`、`plan`、`dailyDirection.recheck`）；
- `dataDate` 为空字符串而不是 null；
- 能力状态是 `"available"`——第一版按 `status == 'active'` 判断可见性，
  状态机里根本没有这个值，8 个入口会全部静默消失；
- 8 条能力的 `gating` 是空对象 `{}`（已知问题 B3）。

## 数据安全

采集账号是一个**当天没有同步数据**的 dev 账号，因此快照里只有模板文案，
不含心率、睡眠等具体健康数值，也不含用户 id、邮箱或令牌。

重新采集时必须确认这一点：如果换成一个有数据的账号，响应里会带真实健康数据，
而健康数据属于 LGPD 定义的敏感数据，不能提交到代码仓库。建议继续用无数据账号，
或在提交前把 `context`、`dailyDirection`、`earlySignal`、`recentInsights` 里的
数值字段置空。

## 重新采集

`tools/capture_atlas_fixtures.py` 需要在服务器上执行（它从
`etc/config_dev.yaml` 读 JWT 密钥与数据库连接串，并直接请求
`127.0.0.1:8081`，不经公网）。它只发 GET，不改任何数据。

```sh
scp tools/capture_atlas_fixtures.py root@<host>:/tmp/
ssh root@<host> "python3 /tmp/capture_atlas_fixtures.py"
scp "root@<host>:/tmp/atlas_fixture/*.json" test/fixtures/
ssh root@<host> "rm -rf /tmp/atlas_fixture /tmp/capture_atlas_fixtures.py"
```

脚本会签一个短期访问令牌用于读取。令牌与密钥都不写入快照文件。
