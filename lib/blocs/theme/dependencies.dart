import 'package:flutter_bloc/flutter_bloc.dart';

import 'persistent_storage_imp.dart';
import 'persistent_storage_repository.dart';

List<RepositoryProvider> buildRepositories() {
  return [
    RepositoryProvider<PersistentStorageRepository>(
      create: (_) => PersistentStorageImpl(),
    ),
  ];
}
