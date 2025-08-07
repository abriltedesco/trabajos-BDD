const circulito = document.getElementById("circulo");
const botonsito = document.getElementById("boton");
const inputColor = document.getElementById("colorIngresado");
const error = document.getElementById("textoError");

botonsito.addEventListener("click", () => {
    const color = inputColor.value;
    error.innerText = "se ingresó bien"
    if(color.length != 7 || color.charAt(0) != "#"){
        error.innerText = "no ingresaste 7 caracteres o no pusiste #";
    }
    else{
        circulito.style.backgroundColor = color;
    }
});
