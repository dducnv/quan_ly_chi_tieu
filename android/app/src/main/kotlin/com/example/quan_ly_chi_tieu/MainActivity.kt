package com.example.quan_ly_chi_tieu

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.SplashScreen

class MainActivity: FlutterActivity() {
       override fun provideSplashScreen(): SplashScreen? = SplashView()
}
