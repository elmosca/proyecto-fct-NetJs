import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Este widget es la raíz de tu aplicación.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Este es el tema de tu aplicación.
        //
        // PRUEBA ESTO: Try ejecutando tu aplicación con "flutter run". Verás
        // que la aplicación tiene una barra de herramientas púrpura. Luego, sin cerrar la app,
        // intenta cambiar el seedColor en el colorScheme de abajo a Colors.green
        // y luego invoca "hot reload" (guarda tus cambios o presiona el botón "hot
        // reload" en un IDE compatible con Flutter, o presiona "r" si usaste
        // la línea de comandos para iniciar la app).
        //
        // Observa que el contador no se reinició a cero; el estado de la aplicación
        // no se pierde durante la recarga. Para reiniciar el estado, usa hot
        // restart en su lugar.
        //
        // Esto funciona también para el código, no solo para valores: La mayoría de cambios de código pueden ser
        // probados con solo un hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // Este widget es la página principal de tu aplicación. Es stateful, lo que significa
  // que tiene un objeto State (definido abajo) que contiene campos que afectan
  // cómo se ve.

  // Esta clase es la configuración para el estado. Contiene los valores (en este
  // caso el título) proporcionados por el padre (en este caso el widget App) y
  // usados por el método build del State. Los campos en una subclase Widget son
  // siempre marcados como "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // Esta llamada a setState le dice al framework de Flutter que algo ha
      // cambiado en este State, lo que causa que se vuelva a ejecutar el método build de abajo
      // para que la pantalla pueda reflejar los valores actualizados. Si cambiáramos
      // _counter sin llamar setState(), entonces el método build no sería
      // llamado de nuevo, y por tanto nada parecería suceder.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Este método se vuelve a ejecutar cada vez que setState es llamado, por ejemplo como se hace
    // por el método _incrementCounter de arriba.
    //
    // El framework de Flutter ha sido optimizado para hacer que la re-ejecución de métodos build
    // sea rápida, para que puedas simplemente reconstruir cualquier cosa que necesite actualizarse en lugar
    // de tener que cambiar individualmente instancias de widgets.
    return Scaffold(
      appBar: AppBar(
        // PRUEBA ESTO: Intenta cambiar el color aquí a un color específico (a
        // Colors.amber, ¿quizás?) y activa un hot reload para ver el AppBar
        // cambiar de color mientras los otros colores permanecen igual.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Aquí tomamos el valor del objeto MyHomePage que fue creado por
        // el método App.build, y lo usamos para establecer el título de nuestra appbar.
        title: Text(widget.title),
      ),
      body: Center(
        // Center es un widget de diseño. Toma un solo hijo y lo posiciona
        // en el medio del padre.
        child: Column(
          // Column es también un widget de diseño. Toma una lista de hijos y
          // los organiza verticalmente. Por defecto, se dimensiona para ajustarse a sus
          // hijos horizontalmente, e intenta ser tan alto como su padre.
          //
          // Column tiene varias propiedades para controlar cómo se dimensiona y
          // cómo posiciona a sus hijos. Aquí usamos mainAxisAlignment para
          // centrar los hijos verticalmente; el eje principal aquí es el eje vertical
          // porque las Columns son verticales (el eje transversal sería
          // horizontal).
          //
          // PRUEBA ESTO: Invoca "debug painting" (elige la acción "Toggle Debug Paint"
          // en el IDE, o presiona "p" en la consola), para ver la
          // estructura de alambre para cada widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Has presionado el botón esta cantidad de veces:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Incrementar',
        child: const Icon(Icons.add),
      ), // Esta coma final hace que el auto-formateo sea más agradable para los métodos build.
    );
  }
}