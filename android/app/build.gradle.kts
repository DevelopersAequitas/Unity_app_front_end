plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.unity_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Default base application ID
        applicationId = "com.peers.peersunity"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "default"

    productFlavors {
        create("peersGlobal") {
            dimension = "default"
            applicationId = "com.peers.peersunity"
            resValue("string", "app_name", "Peers Global Unity")
        }
        create("greenpreneur") {
            dimension = "default"
            applicationId = "com.unity.greenpreneur"
            resValue("string", "app_name", "Greenpreneur Unity")
        }
        create("fempreneur") {
            dimension = "default"
            applicationId = "com.unity.fempreneur"
            resValue("string", "app_name", "Fempreneur Unity")
        }
    }

    buildTypes {
        release {
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
