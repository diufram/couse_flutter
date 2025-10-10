import 'package:flutter_base_app/features/auth/domain/repositories/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// Core
import '../network/dio_client.dart';
import '../storage/prefs_service.dart';
import '../theme/theme_provider.dart';

// AUTH
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

// PRODUCT
import 'package:flutter_base_app/features/product/data/datasources/product_remote_data_source.dart';
import 'package:flutter_base_app/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_base_app/features/product/domain/repositories/product_repository.dart';
import 'package:flutter_base_app/features/product/presentation/provider/product_provider.dart';
// Asegúrate que la clase se llame ProductProvider en este archivo.

class AppDI {
  final DioClient dioClient;
  final PrefsService prefs;

  // Auth
  final AuthRemoteDataSource authRemote;
  final AuthRepository authRepository;
  final LoginUseCase loginUseCase;

  // Product
  final ProductRepository productRepository;

  AppDI._({
    required this.dioClient,
    required this.prefs,
    required this.authRemote,
    required this.authRepository,
    required this.loginUseCase,
    required this.productRepository,
  });

  factory AppDI.create({required String baseUrl, required PrefsService prefs}) {
    // Core
    final dioClient = DioClient(baseUrl);

    // Auth
    final authRemote = AuthRemoteDataSource(dioClient.dio);
    final authRepo = AuthRepositoryImpl(authRemote);
    final loginUC = LoginUseCase(authRepo);

    // Product
    final productsRemote = ProductRemoteDataSource(dioClient.dio);
    final ProductRepository productsRepo = ProductRepositoryImpl(
      productsRemote,
    );

    return AppDI._(
      dioClient: dioClient,
      prefs: prefs,
      authRemote: authRemote,
      authRepository: authRepo,
      loginUseCase: loginUC,
      productRepository: productsRepo,
    );
  }

  List<SingleChildWidget> providers() => [
    // Core
    Provider.value(value: dioClient),
    Provider.value(value: prefs),
    ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),

    // Auth
    Provider<AuthRepository>.value(value: authRepository),
    Provider<LoginUseCase>.value(value: loginUseCase),
    ChangeNotifierProvider(create: (_) => AuthProvider(loginUseCase, prefs)),

    // Product
    Provider<ProductRepository>.value(value: productRepository),
    ChangeNotifierProvider(create: (_) => ProductsProvider(productRepository)),
  ];
}
