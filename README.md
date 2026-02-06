# HABIT CONTROL

<p align="center">
  <img src="assets/icon/habit_control_logo.png" alt="Habit Control Logo" width="140"/>
</p>

**Habit Control** es una aplicación móvil desarrollada en **Flutter** cuyo objetivo es analizar hábitos diarios y ofrecer métricas visuales claras sobre el rendimiento personal.  
No es un simple rastreador de hábitos, sino una **consola de control personal basada en datos**.

> _“No es un rastreador de hábitos; es el analizador de por qué eres como eres.”_ :contentReference[oaicite:0]{index=0}

---

## 📱 Descripción del Proyecto

Este proyecto ha sido desarrollado como **trabajo académico**, con el objetivo de aplicar:
- Arquitectura de aplicaciones Flutter
- Diseño de interfaces profesionales
- Gestión de estados y navegación
- Buenas prácticas de UX/UI

La aplicación sigue una estética **dark / dashboard profesional**, inspirada en paneles de control financieros y sistemas de monitorización.

---

## 🧠 Concepto y Propuesta de Valor

A diferencia de otras apps de hábitos:
- No se limita a almacenar datos
- Prioriza la **visualización clara**
- Busca que el usuario **entienda patrones de comportamiento**

La idea central es correlacionar hábitos diarios con métricas como consistencia, energía o productividad :contentReference[oaicite:1]{index=1}.

---

## 🖥️ Pantallas Principales

### 00. Splash Screen
Pantalla inicial con identidad visual de la app.  
Se utiliza como transición mientras la aplicación se inicializa.

### 01. Login
Pantalla de acceso del usuario.
- Campos de identificación
- Diseño minimalista
- Preparada para futura autenticación

### 02. Dashboard
Panel principal de la aplicación.
- Indicador de rendimiento global (%)
- Información contextual (estado, clima, etc.)
- Lista de hábitos activos

### 03. Registro Diario
Pantalla para introducir métricas del día:
- Horas de sueño
- Nivel de energía
- Tiempo en RRSS
- Confirmación rápida mediante controles simples

### 04. Analíticas
Visualización de datos históricos:
- Gráficas de consistencia
- Rachas activas
- Frases motivacionales basadas en disciplina

### 05. Menú / Navegación
Acceso a:
- Dashboard
- Registro de datos
- Analíticas
- Información de la app

### 06. Créditos
Pantalla informativa con:
- Arquitectura del sistema
- Tecnologías utilizadas
- Información del proyecto académico

---

## 🎨 Estética y UX

- Modo oscuro por defecto
- Colores fríos y contrastes suaves
- Tipografía clara y profesional
- Interfaz pensada para **lectura rápida y análisis visual**

Este enfoque busca una “dopamina fría”: satisfacción a través del orden y la claridad visual :contentReference[oaicite:2]{index=2}.

---

## 🛠️ Tecnologías Utilizadas

- **Flutter**
- **Dart**
- Widgets Material
- Gráficos personalizados
- Navegación por rutas

---

## 🚀 Ejecución del Proyecto

```bash
flutter pub get
flutter run
