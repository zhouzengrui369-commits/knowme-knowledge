# sherpa-onnx JNI 入口保留
-keep class com.k2fsa.sherpa.onnx.** { *; }
# kotlinx serialization
-keepattributes *Annotation*, InnerClasses
-dontnote kotlinx.serialization.AnnotationsKt
-keepclassmembers class kotlinx.serialization.json.** { *** Companion; }
-keepclasseswithmembers class **$serializer { *; }
-dontwarn okio.**
