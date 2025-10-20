# Keep Sceneform classes
-keep class com.google.ar.sceneform.** { *; }
-keep class com.google.ar.core.** { *; }
-keep class com.google.ar.core.exceptions.** { *; }
-keep class com.google.android.filament.** { *; }
-keep interface com.google.ar.core.** { *; }

# Keep Sceneform plugin
-keep class com.google.ar.** { *; }

# Keep Google Play Core library
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Keep Flutter classes
-keep class io.flutter.** { *; }
-keep class androidx.** { *; }

# Flutter's default rules.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.embedding.**  { *; }
-keep class com.google.ar.** { *; }
-keep class com.difrancescogianmarco.arcore_flutter_plugin.** { *; }

# Dontwarn
-dontwarn com.google.ar.sceneform.**
-dontwarn com.google.ar.core.**
-dontwarn com.google.android.filament.**
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.**