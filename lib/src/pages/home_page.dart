import 'package:flutter/material.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/services/peliculas_service.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final peliculasService = new PeliculasService();

  @override
  Widget build(BuildContext context) {
    peliculasService.getPopulares();
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text('peliculas en cines'),
          backgroundColor: Colors.indigoAccent,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            })
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _swiperTarjetas(peliculasService),
              _footer(context, peliculasService)
            ],
          ),
        ));
  }

  Widget _swiperTarjetas(PeliculasService peliculasService) {
    return FutureBuilder(
      future: peliculasService.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
              height: 400.0, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context, PeliculasService peliculasService) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Populares',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          SizedBox(height: 5.0,),
          StreamBuilder(
            stream: peliculasService.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(peliculas: snapshot.data, nextPage: peliculasService.getPopulares,);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
