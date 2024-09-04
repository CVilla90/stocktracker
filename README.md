# README

# Stock Tracker

Esta aplicación permite gestionar portafolios de acciones, calcular las ganancias/pérdidas, y obtener el retorno anualizado de un portafolio de inversiones entre dos fechas. Está diseñada para simular la experiencia de invertir en acciones, utilizando precios simulados debido a limitaciones en las APIs gratuitas disponibles.

## Descripción del Proyecto

Este proyecto fue desarrollado como una respuesta a la tarea solicitada por la postulación de Fintual. El objetivo era construir una clase de `Portafolio` que contenga una colección de acciones y un método `Profit` que reciba dos fechas y devuelva la ganancia del portafolio entre esas fechas. Además, se añadió un cálculo de retorno anualizado como "Bonus Track".

### Detalles Técnicos

- **Ruby Version:** 3.1.0
- **Rails Version:** 7.1.4
- **React Version:** 18.2.0
- **Node Version:** 18.x
- **Database:** SQLite
- **API Integrations:** Simulación de precios de acciones (se integró Alpha Vantage para obtener precios reales, pero se utilizó la simulación debido a las limitaciones de la API gratuita).

### Decisiones de Diseño

- **Modelo `InvestmentPortfolio`**: El modelo de portafolio fue nombrado como `InvestmentPortfolio` en lugar de simplemente `Portfolio` para evitar conflictos con otros proyectos existentes y para ser más descriptivo.
- **Simulación de Precios**: Se decidió simular los precios de las acciones debido a las limitaciones de la versión gratuita de la API de Alpha Vantage. Aunque logramos integrar la API para obtener precios reales, el límite de llamadas era demasiado restrictivo para los propósitos de este proyecto. Por lo tanto, los precios de las acciones se simulan localmente, permitiendo una funcionalidad más fluida sin restricciones de llamadas a la API.

## Instalación

1. **Clonar el repositorio:**

   ```bash
   git clone https://github.com/CVilla90/stocktracker.git
   cd stocktracker
   ```

2. **Instalar dependencias para Rails:**

   ```bash
   bundle install
   ```

3. **Instalar dependencias para React:**

   ```bash
   cd portfolio-frontend
   npm install
   ```

4. **Configurar la base de datos:**

   ```bash
   rails db:create
   rails db:migrate
   ```

5. **Iniciar el servidor Rails:**

   ```bash
   rails server
   ```

6. **Iniciar el servidor React:**

   ```bash
   cd portfolio-frontend
   npm start
   ```

## Funcionalidades Principales

### 1. Crear y Administrar Portafolios

Los usuarios pueden crear nuevos portafolios, agregar acciones con precios simulados y cantidades especificadas. Se proporciona una interfaz para ver el rendimiento de cada portafolio, incluyendo ganancias/pérdidas y el retorno anualizado.

### 2. Calcular Ganancias/Pérdidas

El método `Profit` calcula la ganancia o pérdida de un portafolio entre dos fechas dadas. La ganancia se calcula restando el precio añadido al portafolio del precio actual multiplicado por la cantidad de acciones.

### 3. Calcular el Retorno Anualizado

El retorno anualizado se calcula como un promedio ponderado del retorno anualizado de cada acción dentro del portafolio. La fórmula toma en cuenta el peso de cada acción basado en su valor actual en el portafolio.

#### Lógica de Cálculo de Retorno Anualizado:

- **Valor Total del Portafolio**: Se calcula sumando el valor actual de todas las acciones (precio actual multiplicado por la cantidad).
- **Retorno Anualizado Ponderado**: Cada acción contribuye al retorno anualizado del portafolio según su peso en el mismo (proporción de su valor respecto al total). Esto se multiplica por el retorno anualizado de la acción.

**Cálculo Final:**

\[
Retorno \ Anualizado \ del \ Portafolio = \sum \left( rac{Valor \ Actual \ de \ la \ Acción}{Valor \ Total \ del \ Portafolio} 	imes Retorno \ Anualizado \ de \ la \ Acción 
ight) 	imes 100
\]

## Tecnologías Utilizadas

- **Backend**: Ruby on Rails
- **Frontend**: React
- **Base de Datos**: SQLite
- **API para Precios Reales**: Alpha Vantage (implementado pero no utilizado en producción debido a limitaciones)

## Cómo Utilizar la Aplicación

### Crear un Nuevo Portafolio:

Completa el formulario con el nombre del portafolio y selecciona las acciones que deseas agregar con sus cantidades.

### Ver y Analizar Portafolios:

Selecciona un portafolio para ver los detalles, incluyendo el nombre de la acción, cantidad, precio añadido, precio actual, ganancia/pérdida, y retorno anualizado.

### Eliminar Portafolios:

Puedes eliminar cualquier portafolio desde la vista de detalle del mismo.

## Comentarios y Explicaciones Adicionales

- **Simulación de Precios**: Los precios de las acciones son generados aleatoriamente con un factor de fluctuación para simular cambios en el mercado, lo cual permite probar la aplicación sin restricciones.
- **API Alpha Vantage**: A pesar de haber integrado Alpha Vantage para obtener precios reales, las limitaciones de la versión gratuita nos llevaron a optar por simulaciones internas para tener mayor flexibilidad durante el desarrollo y pruebas.

## Futuras Mejoras

- Integrar una versión mejorada de la API para obtener precios en tiempo real con mayores límites de llamadas.
- Mejorar la interfaz de usuario para una experiencia más intuitiva y amigable.
- Añadir funcionalidades adicionales para análisis y predicción de mercado.
