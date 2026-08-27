package com.example.weather_app

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.widget.RemoteViews
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL
import java.util.Locale

class WeatherUpdateWorker(
    appContext: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(appContext, workerParams) {

    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {

        try {

            val context = applicationContext

            // Dados salvos pelo Flutter através do HomeWidget
            val widgetData = HomeWidgetPlugin.getData(context)

            val latitude =
                widgetData.getString("latitude", null)
                    ?.toDoubleOrNull()

            val longitude =
                widgetData.getString("longitude", null)
                    ?.toDoubleOrNull()

            if (latitude == null || longitude == null) {
                return@withContext Result.success()
            }

            val city =
                widgetData.getString(
                    "city_name",
                    "HzClima"
                ) ?: "HzClima"

            val useFahrenheit =
                widgetData.getString(
                    "use_fahrenheit",
                    "false"
                ) == "true"

            val temperatureUnit =
                if (useFahrenheit) {
                    "fahrenheit"
                } else {
                    "celsius"
                }

            val unitSymbol =
                if (useFahrenheit) {
                    "°F"
                } else {
                    "°C"
                }

            val url = buildString {

                append(
                    "https://api.open-meteo.com/v1/forecast"
                )

                append("?latitude=$latitude")
                append("&longitude=$longitude")

                append(
                    "&current=" +
                        "temperature_2m," +
                        "relative_humidity_2m," +
                        "apparent_temperature," +
                        "precipitation," +
                        "wind_speed_10m," +
                        "weather_code"
                )

                append("&temperature_unit=$temperatureUnit")

                append("&timezone=auto")
            }

            val connection =
                URL(url).openConnection()
                    as HttpURLConnection

            connection.requestMethod = "GET"
            connection.connectTimeout = 10000
            connection.readTimeout = 10000

            val responseCode =
                connection.responseCode

            if (responseCode != 200) {
                connection.disconnect()
                return@withContext Result.retry()
            }

            val response =
                connection.inputStream
                    .bufferedReader()
                    .use { it.readText() }

            connection.disconnect()

            val json =
                JSONObject(response)

            val current =
                json.getJSONObject("current")

            val temperature =
                current.getDouble("temperature_2m")

            val feelsLike =
                current.getDouble(
                    "apparent_temperature"
                )

            val weatherCode =
                current.getInt("weather_code")

            val description =
                getWeatherDescription(weatherCode)

            val now =
                java.text.SimpleDateFormat(
                    "HH:mm",
                    Locale.getDefault()
                ).format(
                    java.util.Date()
                )

            val temperatureText =
                "${temperature.roundToInt()}$unitSymbol"

            val feelsText =
                "Sensação ${feelsLike.roundToInt()}$unitSymbol"

            val weatherIcon =
                getWeatherIcon(weatherCode)

            /*
             * Salva os novos dados.
             */
            widgetData.edit()
                .putString(
                    "temperature",
                    temperatureText
                )
                .putString(
                    "feels_like",
                    feelsText
                )
                .putString(
                    "description",
                    description
                )
                .putString(
                    "weather_code",
                    weatherCode.toString()
                )
                .putString(
                    "updated_time",
                    now
                )
                .apply()

            /*
             * Atualiza todos os widgets ativos.
             */
            updateAllWidgets(
                context,
                city,
                temperatureText,
                feelsText,
                description,
                weatherIcon,
                now
            )

            Result.success()

        } catch (e: Exception) {

            Result.retry()
        }
    }

    private fun updateAllWidgets(
        context: Context,
        city: String,
        temperature: String,
        feelsLike: String,
        description: String,
        weatherIcon: String,
        updatedTime: String
    ) {

        val manager =
            AppWidgetManager.getInstance(context)

        val component =
            ComponentName(
                context,
                WeatherHomeWidgetProvider::class.java
            )

        val widgetIds =
            manager.getAppWidgetIds(component)

        for (widgetId in widgetIds) {

            val views =
                RemoteViews(
                    context.packageName,
                    R.layout.weather_home_widget
                )

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
                weatherIcon
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

            manager.updateAppWidget(
                widgetId,
                views
            )
        }
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

    private fun getWeatherDescription(
        code: Int
    ): String {

        return when (code) {

            0 ->
                "Céu limpo"

            1, 2, 3 ->
                "Parcialmente nublado"

            45, 48 ->
                "Neblina"

            51, 53, 55 ->
                "Chuvisco"

            61, 63, 65 ->
                "Chuva"

            71, 73, 75 ->
                "Neve"

            80, 81, 82 ->
                "Pancadas de chuva"

            95, 96, 99 ->
                "Tempestade"

            else ->
                "Condição desconhecida"
        }
    }

    private fun Double.roundToInt(): Int {
        return kotlin.math.round(this).toInt()
    }
}