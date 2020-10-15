import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

import 'package:stripe_app/src/bloc/pagar/pagar_bloc.dart';

import 'package:stripe_app/src/data/tarjetas.dart';
import 'package:stripe_app/src/helpers/helpers.dart';
import 'package:stripe_app/src/pages/tarjeta_page.dart';
import 'package:stripe_app/src/widgets/total_pay_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Pagar'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              mostrarAlerta(context, 'Hola', 'Mundo');
              // mostrarLoading(context);
              // await Future.delayed(Duration(seconds: 1));
              // Navigator.pop(context);
            }
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            width: size.width,
            height: size.height,
            top: size.width * 0.5,
            child: PageView.builder(
              controller: PageController(
                viewportFraction: 0.9
              ),
              physics: BouncingScrollPhysics(),
              itemCount: tarjetas.length,
              itemBuilder: (_, i) {
                final tarjeta = tarjetas[i];
                return GestureDetector(
                  onTap: () {
                    context.bloc<PagarBloc>().add(OnSeleccionarTarjeta(tarjeta));
                    Navigator.push(context, navegarFadeIn(context, TarjetaPage()));
                  },
                  child: Hero(
                    tag: tarjeta.cardNumber,
                    child: CreditCardWidget(
                      cardNumber: tarjeta.cardNumberHidden,
                      expiryDate: tarjeta.expiracyDate,
                      cardHolderName: tarjeta.cardHolderName,
                      cvvCode: tarjeta.cvv,
                      showBackView: false,
                      cardBgColor: _cardColor(tarjeta.brand),
                    ),
                  ),
                );
              }
            ),
          ),
          Positioned(
            bottom: 0,
            child: TotalPayButton()
          )
        ],
      )
    );
  }

  _cardColor(String brand) {
    if(brand == 'visa') {
      return Color(0xff1b447b);
    } else if(brand == 'mastercard') {
      return Color(0xffff671b);
    } else if(brand == 'american express') {
      return Color(0xff629f86);
    }
  }
}