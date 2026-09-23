import '../app_config.dart';
import '../app_flavor.dart';

final AppConfig peersGlobalConfig = AppConfig(
  flavor: AppFlavor.peersGlobal,
  appName: 'Peers Global Unity',
  androidPackageName: 'com.peers.peersunity',
  iosBundleId: 'com.brapps.pgu',
  logoPath: 'assets/logo/peers_global_logo.png',
  appScheme: 'peersunity',
  appDomain: 'peersunity.com',
  devBaseUrl: 'https://dev.peersunity.com/api/v1',
  prodBaseUrl: 'https://dev.peersunity.com/api/v1', // Development base URL for both prod and dev for release testing
  appStoreUrl: 'https://apps.apple.com/in/app/peers-global-unity/id6739198477',
  appStoreId: '6739198477',
);
