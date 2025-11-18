import 'package:catalog_3d/features/item/view/create_item.dart';
import 'package:catalog_3d/features/item/view/edit_item.dart';
import 'package:catalog_3d/features/item/view/item_list.dart';
import 'package:catalog_3d/features/item/view/view_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const ItemList();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'create_item',
          builder: (BuildContext context, GoRouterState state) {
            return const CreateItem();
          },
        ),
        GoRoute(
          path: '/details/:itemId',
          builder: (context, state) {
            final itemId = state.pathParameters['itemId'];
            return ViewItem(itemId: itemId!);
          },
        ),
        GoRoute(
          path: '/edit/:itemId',
          builder: (context, state) {
            final itemId = state.pathParameters['itemId'];
            return EditItem(itemId: itemId!);
          },
        ),
      ],
    ),
  ],
);
