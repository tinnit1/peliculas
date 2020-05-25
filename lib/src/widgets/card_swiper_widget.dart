import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        itemWidth: _size.width * 0.7,
        itemHeight: _size.height * 0.5,
        layout: SwiperLayout.STACK,
        itemBuilder: (BuildContext context, int index) {
          peliculas[index].uniqueId = '${peliculas[index].id}-tarjetas';
          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'detalle',
                        arguments: peliculas[index]),
                  child: FadeInImage(
                      placeholder: AssetImage('assets/img/no-image.jpg'),
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        peliculas[index].getPosterImg(),
                      )),
                )),
          );
        },
        itemCount: peliculas.length,
      ),
    );
  }
}
