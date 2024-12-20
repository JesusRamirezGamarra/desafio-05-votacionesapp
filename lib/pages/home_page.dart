import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  // Referencia a la colección PARTIDO_POLITICO ordenada por 'vote'
  final CollectionReference partidoRef =
      FirebaseFirestore.instance.collection('PARTIDO_POLITICO');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VOTACIONES"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Ordenar por 'vote' en orden descendente
        stream: partidoRef.orderBy('vote', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay partidos disponibles."));
          }

          final partidos = snapshot.data!.docs; // Lista de documentos

          return ListView.builder(
            itemCount: partidos.length,
            itemBuilder: (context, index) {
              // Obtener los datos del documento
              final partido = partidos[index];
              final String name = partido['name'] ?? 'Nombre no disponible';
              final int votes = partido['vote'] ?? 0;
              final String candidato = partido['candidate'] ?? 'Candidato no disponible';
              final String imageUrl = partido['url'] ??
                  'https://via.placeholder.com/50'; // URL de imagen predeterminada
              print("Image: " + imageUrl);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  //color: Colors.grey[200],
                  gradient: LinearGradient(
                    colors: [Colors.red.shade900, Colors.green.shade50], // Degradado de rojo a blanco
                    stops: const [0.0, 0.9], 
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),                  
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Imagen desde la URL
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Bordes redondeados
                      child: Image.network(
                        imageUrl,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 150, color: Colors.grey);
                        },
                      ),
                    ),
                    // Información del partido
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "PARTIDO", // Título fijo
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name, // Nombre del partido
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          candidato, // Mostrar el contenido del campo 'candidato'
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    // Contador con flechas
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_upward),
                          onPressed: () {
                            // Incrementar votos
                            partido.reference.update({'vote': votes + 1});
                          },
                        ),
                        Text(
                          "$votes",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_downward),
                          onPressed: () {
                            // Decrementar votos
                            partido.reference.update({'vote': votes - 1});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
