# Dio and HTTP related
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-keep class retrofit2.** { *; }
-keep class com.squareup.** { *; }

# Prevent obfuscation of models (optional, if needed)
-keep class your.package.name.models.** { *; }