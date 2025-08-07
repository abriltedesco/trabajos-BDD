var nombreIngresado;
var apellidoIngresado;
var edadIngresada;
var contraIngresada;
var celIngresado;
const error = $("#msjError");

function comprobaciones(){
    if(nombreIngresado.includes(" ") || apellidoIngresado.includes(" ")){
        error.text("nombres ingresados erronamente");
    }
    else if(contrasenia.length < 6){
        error.text("contraseña muy corta");
    }
    else if(edad > 100 || edad < 1){
        error.text("edad invalida");
    }
}

$("#boton").click(function(){
    nombreIngresado = $("#nombre").val();
    apellidoIngresado = $("#apellido").val();
    edadIngresada = $("#edad").val();
    contraIngresada = $("#contrasenia").val();
    celIngresado = $("#celular").val();
    
    comprobaciones()
  }
)








    




const nombreIngresado = document.getElementById("nombre");
const apellidoIngresado = document.getElementById("apellido");
const edadIngresada = document.getElementById("edad");
const contraIngresada = document.getElementById("contrasenia");
const celIngresado = document.getElementById("celular");

const botonsito = document.getElementById("boton");

botonsito.addEventListener("click", () => {
    const contrasenia = contraIngresada.value;
    const edad = edadIngresada.value;
    const nombre = nombreIngresado.value;
    const celular = celIngresado.value;
    const apellido = apellidoIngresado.value;

    if(apellido ){

    }
});*/