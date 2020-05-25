import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/services/peliculas_service.dart';

class DataSearch extends SearchDelegate {
  String selection = '';
  final peliculasService = new PeliculasService();
  final peliculas = ['spiderman', 'capitan a', 'esta es otra', 'otra'];
  final peliculasRecientes = ['Spiderman', 'capi'];
  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de nuestro appBar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appBar
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultado que vamos a mostrar
    return Center(
        child: Container(
      height: 100,
      width: 100,
      color: Colors.blueAccent,
      child: Text(selection),
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias cuando la persona escribe
    if (query.isEmpty) {
      return Container();
    }
    return FutureBuilder(
      future: peliculasService.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula) {
              return ListTile(
                leading: FadeInImage(
                    width: 50.0,
                    fit: BoxFit.contain,
                    placeholder: AssetImage('assets/img/no-image.jpg'),
                    image: NetworkImage(pelicula.getPosterImg())),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
    // final listaSugerida = (query.isEmpty)
    //     ? peliculasRecientes
    //     : peliculas.where(
    //         (element) => element.toLowerCase().startsWith(query.toLowerCase())).toList();
    // return ListView.builder(
    //   itemCount: listaSugerida.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text(listaSugerida[index]),
    //       onTap: () {
    //         selection = listaSugerida[index];
    //         showResults(context);
    //       },
    //     );
    //   },
    // );
  }
}
