const circulito = document.getElementById("circulo");
const botonsito = document.getElementById("boton");

var contadorClicks = 0;
botonsito.addEventListener("click", () => {
    contadorClicks++;
    if( (contadorClicks % 2) == 0){
        circulito.style.backgroundColor = "red";
        console.log(contadorClicks);
    }
    else{
        circulito.style.backgroundColor = "#B4DD1E";
        console.log("entro al else")
    }
});
