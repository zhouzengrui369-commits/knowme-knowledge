pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    // 允许用户全局 init.d 镜像脚本接管仓库（国内网络实测必需）
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "lingxi-mobile-android"
include(":app")
