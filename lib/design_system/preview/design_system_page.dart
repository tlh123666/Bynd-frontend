import 'package:flutter/material.dart';

import '../design_system.dart';

/// 开发期组件预览；可通过 MaterialPageRoute 从开发工具入口打开。
class DesignSystemPage extends StatelessWidget {
  const DesignSystemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BYND · Componentes')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('Cores', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          const Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _ColorChip('Ação', AppColors.action),
              _ColorChip('Slate', AppColors.brandSlate),
              _ColorChip('Sucesso', AppColors.success),
              _ColorChip('Erro', AppColors.error),
              _ColorChip('Info', AppColors.info),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Botões', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              AppButton(
                label: 'Primário',
                iconAsset: AppSvgAssets.more,
                onPressed: () => AppNotice.success(context, 'Ação concluída.'),
              ),
              AppButton(
                label: 'Secundário',
                variant: AppButtonVariant.secondary,
                onPressed: () => AppNotice.show(
                  context,
                  kind: AppNoticeKind.info,
                  message: 'Este é um aviso informativo.',
                ),
              ),
              AppButton(
                label: 'Texto',
                variant: AppButtonVariant.ghost,
                onPressed: () => AppNotice.error(context, 'A ação falhou.'),
              ),
              AppButton(
                label: 'Remover',
                variant: AppButtonVariant.danger,
                onPressed: () => AppNotice.show(
                  context,
                  kind: AppNoticeKind.warning,
                  message: 'Confirme antes de remover.',
                ),
              ),
              const AppButton(
                label: 'Carregando',
                onPressed: null,
                loading: true,
              ),
              const AppButton(label: 'Desativado', onPressed: null),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Cartões', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            onTap: () => AppNotice.success(context, 'Cartão selecionado.'),
            child: const _CardContent(
              title: 'Cartão de vidro',
              subtitle: 'Superfície translúcida com borda suave.',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const AppCard(
            variant: AppCardVariant.solid,
            child: _CardContent(
              title: 'Cartão sólido',
              subtitle: 'Para informação que precisa de mais contraste.',
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Avisos', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          const AppNotice(
            kind: AppNoticeKind.success,
            title: 'Sucesso',
            message: 'A operação foi concluída.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const AppNotice(
            kind: AppNoticeKind.error,
            title: 'Erro',
            message: 'Não foi possível concluir a operação.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const AppNotice(
            kind: AppNoticeKind.warning,
            title: 'Atenção',
            message: 'Verifique os dados antes de continuar.',
          ),
          const SizedBox(height: AppSpacing.sm),
          const AppNotice(
            kind: AppNoticeKind.info,
            title: 'Informação',
            message: 'Uma atualização está disponível.',
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Loading', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          const Center(child: AppLoadingIndicator()),
          const SizedBox(height: AppSpacing.xl),
          Text('Ícones', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              AppIconButton(
                asset: AppSvgAssets.home,
                label: 'Início',
                onPressed: () {},
              ),
              AppIconButton(
                asset: AppSvgAssets.atlas,
                label: 'Atlas',
                onPressed: () {},
              ),
              AppIconButton(
                asset: AppSvgAssets.more,
                label: 'Ações rápidas',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 10, backgroundColor: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.label.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.title),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
