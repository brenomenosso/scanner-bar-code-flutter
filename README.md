# horizontal_barcode_scanner

A new Flutter project.

## Getting Started

Para ultilização: 

1 - Importar package no arquivo pubspec.yaml
  - Exemplo: 
    
  ```  
    horizontal_barcode_scanner:
    git:
      url: https://github.com/brenomenosso/weepay_horizontal_barcode_scanner.git
      ref: main
  ```    

2 - Após isso, exedcutar o comando abaixo para atualizar as dependências do projeto
  - Exemplo: 

  ```  
    flutter pub get
  ```  

3 - Importar o componente na tela
  - Exemplo: 
        
  ```
    import 'package:horizontal_barcode_scanner/horizontal_barcode_scanner.dart';
  ```  

4 - Utilizar o componente na tela 
  - Exemplo  

  **OBS: Aconselhado usar sempre a resolução preset Medium**

  ```
    HorizontalBarcodeScanner.open(
      context: context,
      cameraResolution: ResolutionPreset.medium,
      showLine: true,
      lineColor: Colors.yellow,
      lineWidth: 2,
      label: 'Aponte o leitor para o código de barras.',
      labelSize: 14,
      goBackLabel: 'Sair',
      flashLightLabel: 'Lanterna',
      loadingWidget: Text(
          'Iniciando câmera...',
          style: TextStyle(
          fontSize: 12,
          color: Colors.white,
          ),
      ),
      scannerHeight: 140,
      onSuccess: (code) {
          //Código de barras lido com sucesso
          _barCodeController.text = code;
      },
      onError: (error) {
          //Erro na leitura do código de barras
          print(error);
      },
      onCancel: () {
          //Usuário cancelou antes de ler o código
          print('Cancelado');
      },
    );  
  ```        
