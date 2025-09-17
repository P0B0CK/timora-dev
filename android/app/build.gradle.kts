plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "timora.develop.timora"
    compileSdk = 35
    buildToolsVersion = "35.0.0"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "timora.dev.app"
        minSdk = 23
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    flavorDimensions += "env"

    productFlavors {
        create("dev") {
            dimension = "env"
            applicationId = "timora.dev.app"
        }
        create("staging") {
            dimension = "env"
            applicationId = "timora.staging.app"
        }
        create("prod") {
            dimension = "env"
            applicationId = "timora.prod.app"
        }
    }

}

flutter {
    source = "../.."
}

apply(plugin = "com.google.gms.google-services")
