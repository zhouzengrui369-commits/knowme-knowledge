package com.lingxi.mobile.ui.nav

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.lingxi.mobile.ui.screens.KnowledgeScreen
import com.lingxi.mobile.ui.screens.LingxiHomeScreen
import com.lingxi.mobile.ui.screens.ProfileScreen
import com.lingxi.mobile.ui.screens.RecordsScreen

/** 四个目的地（合同冻结）：灵犀 / 记录 / 知识 / 我的。 */
object Dest {
    const val LINGXI = "lingxi"
    const val RECORDS = "records"
    const val KNOWLEDGE = "knowledge"
    const val PROFILE = "profile"

    val items = listOf(
        LINGXI to "灵犀",
        RECORDS to "记录",
        KNOWLEDGE to "知识",
        PROFILE to "我的",
    )
}

@Composable
fun LingxiNavHost() {
    val nav = rememberNavController()
    val backStack by nav.currentBackStackEntryAsState()
    val current = backStack?.destination?.route ?: Dest.LINGXI

    Scaffold(
        bottomBar = {
            NavigationBar {
                Dest.items.forEach { (route, label) ->
                    NavigationBarItem(
                        selected = current == route,
                        onClick = {
                            nav.navigate(route) {
                                popUpTo(nav.graph.findStartDestination().id) { saveState = true }
                                launchSingleTop = true
                                restoreState = true
                            }
                        },
                        icon = { Text(label.take(1)) },
                        label = { Text(label) },
                    )
                }
            }
        },
    ) { padding ->
        NavHost(
            navController = nav,
            startDestination = Dest.LINGXI,
            modifier = Modifier.padding(padding),
        ) {
            composable(Dest.LINGXI) { LingxiHomeScreen() }
            composable(Dest.RECORDS) { RecordsScreen() }
            composable(Dest.KNOWLEDGE) { KnowledgeScreen() }
            composable(Dest.PROFILE) { ProfileScreen() }
        }
    }
}
