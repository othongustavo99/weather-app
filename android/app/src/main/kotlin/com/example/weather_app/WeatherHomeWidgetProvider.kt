package com.example.weather_app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.util.concurrent.TimeUnit

class WeatherHomeWidgetProvider : HomeWidgetProvider() {

    companion object {

        private const val WORK_NAME =
            "hzclima_weather_update"

        private const val UPDATE_INTERVAL_HOURS =
            1L
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {

        /*
         * Garante que o atualizador esteja agendado.
         */
        scheduleWeatherWorker(context)

        appWidgetIds.forEach { widgetId ->

            val views =
                RemoteViews(
                    context.packageName,
                    R.layout.weather_home_widget
                )

            val city =
                widgetData.getString(
                    "city_name",
                    "HzClima"
                ) ?: "HzClima"

            val temperature =
                widgetData.getString(
                    "temperature",
                    "--"
                ) ?: "--"

            val description =
                widgetData.getString(
                    "description",
                    "Abra o app para atualizar"
                ) ?: "Abra o app para atualizar"

            val feelsLike =
                widgetData.getString(
                    "feels_like",
                    ""
                ) ?: ""

            val updatedTime =
                widgetData.getString(
                    "updated_time",
                    "--:--"
                ) ?: "--:--"

            val weatherCode =
                widgetData.getString(
                    "weather_code",
                    "0"
                )?.toIntOrNull() ?: 0

            views.setTextViewText(
                R.id.widget_city,
                city
            )

            views.setTextViewText(
                R.id.widget_temperature,
                temperature
            )

            views.setTextViewText(
                R.id.widget_description,
                description
            )

            views.setTextViewText(
                R.id.widget_feels,
                feelsLike
            )

            views.setTextViewText(
                R.id.widget_updated,
                "Atualizado $updatedTime"
            )

            views.setTextViewText(
                R.id.widget_weather_icon,
                getWeatherIcon(weatherCode)
            )

            val pendingIntent =
                HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )

            views.setOnClickPendingIntent(
                R.id.widget_root,
                pendingIntent
            )

            appWidgetManager.updateAppWidget(
                widgetId,
                views
            )
        }
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)

        scheduleWeatherWorker(context)
    }

    override fun onDisabled(context: Context) {

        WorkManager
            .getInstance(context)
            .cancelUniqueWork(WORK_NAME)

        super.onDisabled(context)
    }

    private fun scheduleWeatherWorker(
        context: Context
    ) {

        val request =
            PeriodicWorkRequestBuilder<WeatherUpdateWorker>(
                UPDATE_INTERVAL_HOURS,
                TimeUnit.HOURS
            )
                .build()

        WorkManager
            .getInstance(context)
            .enqueueUniquePeriodicWork(
                WORK_NAME,
                ExistingPeriodicWorkPolicy.KEEP,
                request
            )
    }

    private fun getWeatherIcon(
        code: Int
    ): String {

        return when (code) {

            0 -> "☀"

            1, 2, 3 -> "☁"

            45, 48 -> "🌫"

            51, 53, 55,
            61, 63, 65,
            80, 81, 82 -> "🌧"

            71, 73, 75 -> "❄"

            95, 96, 99 -> "⛈"

            else -> "☁"
        }
    }
}