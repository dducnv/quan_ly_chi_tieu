package com.example.quan_ly_chi_tieu;

import android.app.PendingIntent
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color


import android.widget.RemoteViews;
import es.antonborri.home_widget.HomeWidgetPlugin;

/**
 * Implementation of App Widget functionality.
 */
class TotalByDayWidget : AppWidgetProvider() {
        override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.total_by_day_widget).apply {

                val title = widgetData.getString("headline_title", null)
            
                setTextViewText(R.id.headline_title, title ?: "No title set")

                val amount = title?.replace("[^\\d.]".toRegex(), "")?.toDoubleOrNull()?.toInt()

                
                val desc = widgetData.getString("headline_description", null)
                setTextViewText(R.id.headline_description, desc ?: "No description set")

                // val imgPath = widgetData.getString("widget_image", null)
                // if (imgPath != null) {
                //     val imgResourceId = context.resources.getIdentifier(imgPath, "drawable", context.packageName)
                //     if (imgResourceId != 0) {
                //         setImageViewResource(R.id.widget_image, imgResourceId)
                //     }
                // }
                val targetPackageName = "com.example.quan_ly_chi_tieu" // Replace with the package name of the app you want to open
                val intent = context.packageManager.getLaunchIntentForPackage(targetPackageName)

                // Check if the intent is not null before creating the PendingIntent
                if (intent != null) {
                    // Use FLAG_IMMUTABLE to ensure security and stability
                    val pendingIntent =
                        PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)
                    setOnClickPendingIntent(R.id.widget_container, pendingIntent)
                }
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

