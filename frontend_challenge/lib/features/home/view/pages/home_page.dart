import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_challenge/core/extensions/context.dart';
import 'package:frontend_challenge/core/theme/app_pallete.dart';
import 'package:frontend_challenge/core/theme/theme.dart';
import 'package:frontend_challenge/core/widgets/custom_scaffold.dart';
import 'package:frontend_challenge/features/home/models/customer_model.dart';
import 'package:frontend_challenge/features/home/view/widgets/customer_entrance_modal.dart';
import 'package:frontend_challenge/features/home/view/widgets/menu_button_item.dart';
import 'package:frontend_challenge/features/home/viewmodel/filter_clients_provider.dart';
import 'package:frontend_challenge/features/home/viewmodel/paginated_clients_rovider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final EdgeInsets _horizontalPadding =
      const EdgeInsets.symmetric(horizontal: 32);
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      padding: EdgeInsets.zero,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.fitHeight,
              height: 80,
            ),
          ),
          SliverPadding(
            padding: _horizontalPadding.copyWith(top: 20),
            sliver: const SliverToBoxAdapter(
              child: _SearchBar(),
            ),
          ),
          SliverPadding(
            padding: _horizontalPadding.copyWith(top: 20),
            sliver: const _SliverList(),
          ),
          SliverPadding(
            padding: _horizontalPadding.copyWith(top: 30, bottom: 20),
            sliver: const SliverToBoxAdapter(
              child: _LoadMoreButton(),
            ),
          )
        ],
      ),
    );
  }
}

class _SliverList extends ConsumerWidget {
  const _SliverList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paginatedClientsProvider);
    final clients = ref.watch(filterClientsProvider);

    final isInitialLoading = state.isLoading && clients.isEmpty;

    return isInitialLoading
        ? const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
        : SliverList.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final customer = clients[index];
              return _Item(
                key: ValueKey(index),
                customer: customer,
              );
            });
  }
}

class _SearchBar extends ConsumerWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Clients',
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 40,
          child: Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: TextField(
                  onChanged: (value) {
                    ref
                        .read(filterClientsProvider.notifier)
                        .filterByQuery(value);
                  },
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: context.theme.elevatedBlackPill.copyWith(
                  padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(
                horizontal: 12,
              ))),
              onPressed: () {
                const CustomerEntranceModal(null).show(context);
              },
              child: const Text('Add new'),
            ),
          ]),
        ),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  final CustomerModel customer;
  const _Item({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.hardEdge,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 1,
              color: Pallete.blackColor,
            ),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage:
                  customer.hasImage ? NetworkImage(customer.imageUrl) : null,
            ),
            title: Text(customer.fullName),
            subtitle: Text(customer.email),
            trailing: MenuButtonItem(customer),
          ),
        ),
      ),
    );
  }
}

class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Center(
        child: SizedBox(
          height: 52,
          width: 296,
          child: Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(paginatedClientsProvider);

              return state.when(
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                  error: (error, stackTrace) =>
                      Center(child: Text(error.toString())),
                  data: (data) {
                    final isEmpty = data?.items?.isEmpty ?? true;
                    final isLastPage = data?.isLastPage;

                    if (isLastPage == true && !isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return ElevatedButton(
                        style: context.theme.elevatedBlackPill,
                        onPressed: isEmpty
                            ? () {
                                const CustomerEntranceModal(null).show(context);
                              }
                            : () {
                                ref
                                    .read(paginatedClientsProvider.notifier)
                                    .nextPage();
                              },
                        child: Text(isEmpty ? 'Add new' : 'Load more'));
                  });
            },
          ),
        ),
      ),
    );
  }
}
