import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'package:stripe_app/src/models/stripe_custom_response.dart';
import 'package:stripe_app/src/models/payment_intent_response.dart';

class StripeService {
  // Singleton
  StripeService._privateContructor();

  static final StripeService _instance = StripeService._privateContructor();

  factory StripeService() => _instance;

  String _paymentApiUrl = 'https://api.stripe.com/v1/payment_intents';
  String _apiKey = 'pk_test_51HcXrQHuDaUu1Nk6yPujX6iwwiWci52UUyOjtpJvvHfUxgWO2WyCq7F7k8FQI03sMVhbsQPfiHQG2bPuVgbfqEdP00jjwSYq1L';
  static String _secretKey = 'sk_test_51HcXrQHuDaUu1Nk6uieKJqCwtxpQ3O2s4kdzbX3YNd5EYFuIhItlDQcW5WZUdA89hOEQ60NWD1VzfahFslXuS7Ix00PwzmBuN7';

  final headerOptions = new Options(
    contentType: Headers.formUrlEncodedContentType,
    headers: {
      'Authorization': 'Bearer ${StripeService._secretKey}'
    }
  );

  void init() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: this._apiKey,
        androidPayMode: 'test',
        merchantId: 'test'
      )
    );
  }

  Future<StripeCustomResponse> pagarConTarjetaExistente({
    @required String amount,
    @required String currency,
    @required CreditCard card,
  }) async {
    try {
      final paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(card: card)
      );

      final resp = await this._realizarPago(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod
      );

      return resp;
      
    } catch (e) {
      return StripeCustomResponse(
        ok: false,
        msg: e.toString()
      );
    }
    
  }

  Future<StripeCustomResponse> pagarConNuevaTarjeta({
    @required String amount,
    @required String currency,
  }) async {
    try {
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest()
      );

      final resp = await this._realizarPago(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod
      );

      return resp;
      
    } catch (e) {
      return StripeCustomResponse(
        ok: false,
        msg: e.toString()
      );
    }
  }

  Future<StripeCustomResponse> pagarApplePayGooglePay({
    @required String amount,
    @required String currency,
  }) async {
    try {
      final newAmount = double.parse(amount) / 100;
      final token = await StripePayment.paymentRequestWithNativePay(
        androidPayOptions: AndroidPayPaymentRequest(
          totalPrice: amount,
          currencyCode: currency,
        ),
        applePayOptions: ApplePayPaymentOptions(
          countryCode: 'MX',
          currencyCode: currency,
          items: [
            ApplePayItem(
              label: 'Super Producto 1',
              amount: '$newAmount'
            )
          ]
        )
      );

      final paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(
          card: CreditCard(
            token: token.tokenId
          )
        )
      );

      final resp = await this._realizarPago(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod
      );

      await StripePayment.completeNativePayRequest();

      return resp;

    } catch (e) {
      print('Error en intento: ${e.toString()}');
      return StripeCustomResponse(
        ok: false,
        msg: e.toString()
      );
    }
  }

  Future<PaymentIntentResponse> _crearPaymentIntent({
    @required String amount,
    @required String currency,
  }) async {
    try {
      final dio = new Dio();
      final data = {
        'amount': amount,
        'currency': currency
      };
      final resp = await dio.post(
        _paymentApiUrl,
        data: data,
        options: headerOptions
      );

      return PaymentIntentResponse.fromJson(resp.data);

    } catch (e) {
      print('Error en intento: ${e.toString()}');
      return PaymentIntentResponse(
        status: '400'
      );
    }
  }

  Future<StripeCustomResponse> _realizarPago({
    @required String amount,
    @required String currency,
    @required PaymentMethod paymentMethod
  }) async {
    try {
      // Crear el intent
      final paymentIntent = await this._crearPaymentIntent(
        amount: amount,
        currency: currency
      );

      final paymentResult = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent.clientSecret,
          paymentMethodId: paymentMethod.id
        )
      );

      if(paymentResult.status == 'succeeded') {
        return StripeCustomResponse(ok: true);
      } else {
        return StripeCustomResponse(
          ok: false,
          msg: 'Falló: ${paymentResult.status}'
        );
      }
    } catch (e) {
      return StripeCustomResponse(
        ok: false,
        msg: e.toString()
      );
    }
  }
}