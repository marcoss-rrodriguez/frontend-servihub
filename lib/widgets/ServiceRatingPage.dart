import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Service {
  // Asegúrate de que la clase Service tenga una propiedad jobs
  List<Job> jobs;

  Service({required this.jobs});
}

class Job {
  String title;
  String description;
  double rating;

  Job({required this.title, required this.description, this.rating = 0.0});
}

class ServiceRatingPage extends StatelessWidget {
  final Service? service;

  ServiceRatingPage({Key? key, required this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Verifica que el servicio no sea nulo antes de acceder a sus trabajos
    List<Job> jobs = service?.jobs ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluar Trabajos'),
      ),
      body: JobList(jobs: jobs),
    );
  }
}

class JobList extends StatelessWidget {
  final List<Job> jobs;

  JobList({required this.jobs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(jobs[index].title),
          subtitle: Text(jobs[index].description),
          trailing: RatingBar.builder(
            initialRating: jobs[index].rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 20.0,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              // Actualiza la calificación del trabajo
              jobs[index].rating = rating;
            },
          ),
        );
      },
    );
  }
}
