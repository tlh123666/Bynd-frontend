import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val releasePropertiesFile = rootProject.file("key.properties")
val releaseProperties = Properties().apply {
    if (releasePropertiesFile.exists()) releasePropertiesFile.inputStream().use { load(it) }
}
val signingKeys = listOf("storeFile", "storePassword", "keyAlias", "keyPassword")
val releaseSigningReady = signingKeys.all { !releaseProperties.getProperty(it).isNullOrBlank() }

android {
    namespace = "com.bynd.bynd"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Existing Google Play/Firebase identity, retained from JCVital.
        applicationId = "com.byndhealth.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = maxOf(flutter.minSdkVersion, 23)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (releaseSigningReady) {
                storeFile = file(releaseProperties.getProperty("storeFile"))
                storePassword = releaseProperties.getProperty("storePassword")
                keyAlias = releaseProperties.getProperty("keyAlias")
                keyPassword = releaseProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
        debug {
            // Google 登录按「包名 + 签名证书 SHA-1」匹配 OAuth 客户端。默认 debug
            // 证书的指纹虽然已登记到 Firebase，但对应 OAuth 客户端的自动生成要数小
            // 时到一天，期间登录一律报 DEVELOPER_ERROR(10)。本地上传证书的客户端
            // 早已存在，debug 构建直接复用它，flutter run 立即可用。
            // key.properties 缺失时回退默认 debug 签名，不阻塞无签名的开发环境。
            if (releaseSigningReady) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

val verifyReleaseSigning = tasks.register("verifyReleaseSigning") {
    doLast {
        check(releaseSigningReady) {
            "Release signing is missing. Create android/key.properties from key.properties.example and use the ORIGINAL JCVital upload keystore."
        }
        check(file(releaseProperties.getProperty("storeFile")).isFile) {
            "The original release keystore referenced by android/key.properties does not exist."
        }
    }
}
tasks.configureEach {
    if (name == "preReleaseBuild") dependsOn(verifyReleaseSigning)
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Same vendor binary used by JCVital; no replacement BLE protocol.
    implementation(files("libs/v8sdk1.0.jar"))
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    testImplementation("junit:junit:4.13.2")
}
