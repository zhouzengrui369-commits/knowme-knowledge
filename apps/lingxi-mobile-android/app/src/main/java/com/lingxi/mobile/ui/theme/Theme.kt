package com.lingxi.mobile.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val LightColors = lightColorScheme(
    primary = Color(0xFF3355AA),
    onPrimary = Color.White,
    surface = Color(0xFFFCFCFD),
    background = Color(0xFFF6F7F9),
    surfaceVariant = Color(0xFFEDEFF3),
    onSurface = Color(0xFF1C1E21),
    secondary = Color(0xFF5B6472),
    error = Color(0xFFB3261E),
)

private val DarkColors = darkColorScheme(
    primary = Color(0xFF9CB4E8),
    onPrimary = Color(0xFF0E1A33),
    surface = Color(0xFF14161A),
    background = Color(0xFF101214),
    surfaceVariant = Color(0xFF20242A),
    onSurface = Color(0xFFE6E8EB),
    secondary = Color(0xFFA6ADB8),
)

@Composable
fun LingxiTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = if (isSystemInDarkTheme()) DarkColors else LightColors,
        content = content,
    )
}
