import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_challenge/core/extensions/context.dart';
import 'package:frontend_challenge/core/mixins/loading_mixin.dart';
import 'package:frontend_challenge/core/theme/app_pallete.dart';
import 'package:frontend_challenge/core/theme/theme.dart';
import 'package:frontend_challenge/core/utils.dart';
import 'package:frontend_challenge/core/widgets/custom_field.dart';
import 'package:frontend_challenge/features/home/models/customer_model.dart';
import 'package:frontend_challenge/features/home/viewmodel/create_client_provider.dart';
import 'package:frontend_challenge/features/home/viewmodel/select_avatar.dart';
import 'package:frontend_challenge/features/home/viewmodel/update_client_provider.dart';

class CustomerEntranceModal extends StatelessWidget {
  final CustomerModel? customer;
  const CustomerEntranceModal(this.customer, {super.key});

  show(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        showDragHandle: false,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: const Color(0xffFDFDF9),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        builder: (context) => this);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 25, vertical: 16).copyWith(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: _Form(customer: customer),
    );
  }
}

class _Form extends ConsumerStatefulWidget {
  final CustomerModel? customer;
  const _Form({
    required this.customer,
  });

  @override
  ConsumerState<_Form> createState() => _FormState();
}

class _FormState extends ConsumerState<_Form> with LoadingMixin {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _surnameController;
  late final TextEditingController _emailController;

  @override
  initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.firstname);
    _surnameController = TextEditingController(text: widget.customer?.lastname);
    _emailController = TextEditingController(text: widget.customer?.email);
  }

  bool get _isEditing => widget.customer != null;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _isEditing ? "Edit client" : 'Add new client',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 48),
            CustomPaint(
              painter: DottedBorderPainter(),
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Pallete.whiteColor,
                child: InkWell(
                  onTap: () {
                    ref.read(selectAvatarProvider.notifier).pickFiles();
                  },
                  child: SizedBox.square(
                    dimension: 140,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final selectAvatar = ref.watch(selectAvatarProvider);

                        return selectAvatar.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (e, _) => Text("Failed to pick image: $e"),
                          data: (file) {
                            if (file != null) {
                              return Image.file(file);
                            }
                            return (widget.customer?.hasImage ?? false)
                                ? Image.network(widget.customer!.imageUrl,
                                    fit: BoxFit.cover)
                                : Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.image_outlined,
                                            size: 40, color: Colors.black54),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Upload image',
                                          style: context.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            CustomField(
              hintText: 'First name*',
              controller: _nameController,
              validators: const [
                TextValidator.required,
              ],
            ),
            const SizedBox(height: 8),
            CustomField(
              hintText: 'Last name*',
              controller: _surnameController,
              validators: const [
                TextValidator.required,
              ],
            ),
            const SizedBox(height: 8),
            CustomField(
              hintText: 'Email address*',
              controller: _emailController,
              validators: const [TextValidator.required, TextValidator.email],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 36),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                  width: 120,
                  height: 52,
                  child: TextButton(
                      onPressed: Navigator.of(context).pop,
                      child: Text('Cancel',
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Pallete.greyColor,
                          )))),
              SizedBox(
                width: 180,
                height: 52,
                child: ElevatedButton(
                    style: context.theme.elevatedBlackPill,
                    onPressed: () {
                      final customer = CustomerModel(
                        id: widget.customer?.id ?? 'new',
                        firstname: _nameController.text,
                        lastname: _surnameController.text,
                        email: _emailController.text,
                        selectedImage:
                            ref.watch(selectAvatarProvider).asData?.value,
                      );
                      if (_formKey.currentState!.validate()) {
                        if (widget.customer != null) {
                          insetOverlay(() async => await ref
                                  .read(updateClientProvider(customer).future)
                                  .then((_) {
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                  showSnackBar(context, 'Client updated');
                                }
                              }));
                          return;
                        }

                        insetOverlay(() async => await ref
                                .read(createClientProvider(customer).future)
                                .then((_) {
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                showSnackBar(context, 'Client created');
                              }
                            }));
                      }
                    },
                    child: const Text('Save')),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final Color color;

  DottedBorderPainter({this.color = Pallete.primaryColor});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double dotSpacing = 4.0;
    const double dotRadius = 4;

    final double circumference = 2 * 3.141592 * (size.width / 2);
    final int numberOfDots =
        (circumference / (dotRadius * 2 + dotSpacing)).floor();
    final double angleStep = 2 * 3.141592 / numberOfDots;

    for (int i = 0; i < numberOfDots; i++) {
      final double angle = i * angleStep;
      final Offset dotPosition = Offset(
        size.width / 2 + (size.width / 2 - dotRadius) * math.cos(angle),
        size.height / 2 + (size.height / 2 - dotRadius) * math.sin(angle),
      );
      canvas.drawCircle(dotPosition, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
