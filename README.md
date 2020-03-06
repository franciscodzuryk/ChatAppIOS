# ChatApp

Este desarrollo está realizado solo con fines académicos.

<video src="ChatApp.mp4" width="640" height="320" controls preload></video>

### Descripción
Aplicación iOS para comunicar vía chat a N usuarios con una compañia.
Presenta dos modos de login:
- Modo User: Se loguea cómo usuario y chatea con la compañía.
- Modo Company: Se loguea la compañia y chatea con N usurios.

Modo Demo:
Esta modalidad permite recibir un eco de los mensajes, si se uncluye la palabra 'bill' en algún mensaje; la respuesta será un ticket.


#### Aspectos técnicos
Este desarrollo consta de una aplicación para iOS en swift 5.0 y un pequeño servidor web en NodeJS. Link al servidor:

https://github.com/franciscodzuryk/ChatAppSrv


###### Si bien la app puede funcionar con SSL, no está soportada la opción en desarrollo debido a que Apple no permite utilizar certificados propios (no seguros).
#
#### Ejecución de la app
Desde el terminal ejecute:
```sh
$ git clone https://github.com/franciscodzuryk/ChatApp.git
$ cd ChatApp/
$ pod install
```
#### Ejecución del Servidor
```sh
$ git clone https://github.com/franciscodzuryk/ChatAppSrv.git
$ cd ChatAppSrv/
$ npm install
$ node app.js 
```

### Arquitectura
Se utilizó la arquitectura MVC. Muchas veces se ha implementado mal esta arquitectura debido al nombre que Apple le dio a las vistas (UIViewController). Este componente debe representar solo la vista, la vista del controlador. En este sentido podríamos decir que la arquitectura es MVVM donde el VM es en realidad el controller.
En terminos simples esta arquitectura consta  de tres componentes por escenario (pantalla):
- Modelo: Representa los datos de entrada y salida de la aplicación, es la información que se va a utilizar en la aplicación.
- Vista: Es el conjunto de componentes visuales que van a ser mostrados con los datos provenientes del modelo.
- Controlador: Es quien se ocupa de ejecutar el procesamientos de los datos (modelo) y pasarlos a la vista para que los muestre. También es su responsabilidad manejar el sentido opuesto, es decir, tomar los datos de la vista y procesarlos generando instancias de los modelos.

La vista implementa una interface que le es provista al controlador para poder comunicarle actualizaciones en el estado de la pantalla.
El controlador provee una interfaz a la vista para poder realizar peticiones, estas peticiones son funcionalidades completas. Es decir, la vista le pide al controlador que ejecute una funcinalidad y este va a hacer todo lo necesario para completarla; terminando con la actualización de la vista si fuera necesario.

###### Un ejemplo del uso de la arquitectura es la escena de Chat:
- Interface de la vista 'protocol ChatViewInterface: class'
Abstrae los métodos necesarios para comunicarse con la vista, es utilizada por el controlador para informar de cambios en los datos de la Vista

- Interface del Controlador 'protocol ChatCtrler'
Abstrae los métodos del controlador necesarios para que la Vista realice peticiones de ejecución de alguna funcionalidad.


- Implementación de la vista 'class ChatVC: UIViewController'
Se implementa la interface a modo de extención solo para ordenar el código dela vista en: 'extension ChatVC: ChatViewInterface'


- Implementación del controlador 'class ChatUserCtrler: ChatCtrler'
Preste atención que existen dos controladores, uno para el usuario y otro para la compañía. Esto se debe a que se utiliza una misma app para ambos modos. Lo único que cambia es la implementación de la interfaz, haciendo el desarrollo más sencillo y testeable.

- Implementación de los modelos:
-- struct Message: Codable
Representa un mensaje, que puede ser saliente (se envía al servidor) o entrante (se recibe desde el servidor).
-- struct Bill: Codable
Representa un ticket, que al igual que anterior puede ser entrante o saliente.
Estos son dos de los modelos que se utilizan en la aplicación, si presta atención son estructuras y no clases. Esto se debe a que no es necesario pasar la referencia de estos modelos en ningún punto de la app.

- Si observa los modelos:
class User: Codable
class Company: Codable
Ambos son clases y no estructuras, esto se debe a que se retienen y pasan por referencia. 

> Aquí hay un punto importante de mejora. Dado que todo el modelo se mantiene en memoria, es necesario pasar la referencia de estos Modelos para mantenerlos actualizados con los mensajes que entran y salen. Una solución posible sería crear un repositorio en memoria para utilizar desde los Controladores.


### Sistema de polling
Este sistema permite realizar peticiones constantes al servidor de forma estable. Tenga en cuenta que NO es una buena práctica en producción y recuerde que el objetivo de este proyecto es solo con fines académicos.

```swift
func startPolling() {
    let queue = DispatchQueue.global(qos: .background)
    timer = DispatchSource.makeTimerSource(queue: queue) as DispatchSourceTimer
    timer?.schedule(deadline: .now(), repeating: .seconds(2), leeway: .seconds(1))
    timer?.setEventHandler(handler: { [weak self] in
        ...
    })
    timer?.resume()
}

```

### Frameworks utilizados:

##### Alamofire
Facilita la ejecución y configuración de los request al servidor. Puede encontrar su implementación en:
- APIUserClient.swift
- APICompanyClient.swift

##### youtube-ios-player-helper-swift
Facilita la reproducción de videos desde youtube.
En caso de que NO se encuentre conectada la compañía, si el usuario se loguea, se pone a reproducir un video mientras espera que la compañía se conecte.

