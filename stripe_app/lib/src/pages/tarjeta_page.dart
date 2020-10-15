import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

import 'package:stripe_app/src/bloc/pagar/pagar_bloc.dart';
import 'package:stripe_app/src/widgets/total_pay_button.dart';

class TarjetaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tarjeta = context.bloc<PagarBloc>().state.tarjeta;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Pagar'),
        leading: IconButton(
          icon: Icon(
            Platform.isAndroid
            ? Icons.arrow_back
            : Icons.arrow_back_ios,
          ),
          onPressed: () {
            context.bloc<PagarBloc>().add(OnDesactivarTarjeta());
            Navigator.pop(context);
          }
        ),
      ),
      body: Stack(
        children: [
          Container(),
          Hero(
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
          Positioned(
            bottom: 0,
            child: TotalPayButton()
          )
        ],
      ),
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