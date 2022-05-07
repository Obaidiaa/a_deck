
// final prefDataProvider = Provider<SharedPreferencesService>((ref) {
//   return sharedPreferencesServiceProvider;
// });
// final sharedPreferencesServiceProvider =
//     StateNotifierProvider<SharedPreferencesService, Settings>((ref) {
//   final sharedPreferences = SharedPreferences.getInstance();
//   return SharedPreferencesService(sharedPreferences);
// });

// final sharedPreferencesServiceProvider =
//     Provider.autoDispose<SharedPreferencesService>(
//         (ref) => throw );

// final dataProvider = Provider.autoDispose<DataApi?>((ref) {
//   final settings = ref.watch(sharedPreferencesServiceProvider);
//   return DataApi(settings: settings.getSettings());
// });
