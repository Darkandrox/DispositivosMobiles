import 'package:flutter/material.dart';

import '../config/config.dart';
import '../modelos/filtro.modelo.dart';

/// Panel inferior para elegir ciudad, categoría, palabra clave y radio.
/// Al presionar "Buscar" retorna el [Filtro] nuevo con Navigator.pop.
class FiltrosVista extends StatefulWidget {
  final Filtro filtroActual;

  const FiltrosVista({super.key, required this.filtroActual});

  @override
  State<FiltrosVista> createState() => _FiltrosVistaState();
}

class _FiltrosVistaState extends State<FiltrosVista> {
  late final TextEditingController _txtCiudad;
  late final TextEditingController _txtPalabraClave;
  late String _categoria;
  late int _radioKm;

  @override
  void initState() {
    super.initState();
    _txtCiudad = TextEditingController(text: widget.filtroActual.ciudad);
    _txtPalabraClave = TextEditingController(text: widget.filtroActual.palabraClave);
    _categoria = widget.filtroActual.categoria;
    _radioKm = widget.filtroActual.radioKm;
  }

  @override
  void dispose() {
    _txtCiudad.dispose();
    _txtPalabraClave.dispose();
    super.dispose();
  }

  void _buscar() {
    Navigator.pop(
      context,
      Filtro(
        ciudad: _txtCiudad.text,
        categoria: _categoria,
        palabraClave: _txtPalabraClave.text,
        radioKm: _radioKm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Sube el panel cuando aparece el teclado.
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                Config.textoFiltros,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _txtCiudad,
                decoration: const InputDecoration(
                  labelText: Config.textoCiudad,
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _txtPalabraClave,
                decoration: const InputDecoration(
                  labelText: Config.textoPalabraClave,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _categoria,
                decoration: const InputDecoration(labelText: Config.textoCategoria),
                items: Config.categorias.entries.map((categoria) {
                  return DropdownMenuItem(
                    value: categoria.key,
                    child: Row(
                      children: [
                        Icon(Config.iconosCategoria[categoria.key], color: Config.colorPrimario),
                        const SizedBox(width: 10),
                        Text(categoria.value),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (valor) => setState(() => _categoria = valor ?? ''),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _radioKm,
                decoration: const InputDecoration(
                  labelText: Config.textoRadio,
                  prefixIcon: Icon(Icons.radar),
                ),
                items: Config.radiosKm
                    .map((radio) => DropdownMenuItem(value: radio, child: Text('$radio km')))
                    .toList(),
                onChanged: (valor) => setState(() => _radioKm = valor ?? Config.radioPorDefecto),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _buscar,
                icon: const Icon(Icons.search),
                label: const Text(Config.textoBuscar),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
