const botonAgregar = document.getElementById("botonAgregar");
const lista = document.getElementById("lista");
const contenedor = document.getElementById("contenedorConLista");
const avisarError = document.getElementById("textoError");
const itemIngresado = document.getElementById("itemLista");

function eliminarElemento(nuevoElemento) {
    console.log("ingreso a eliminar elemento");
    lista.removeChild(nuevoElemento);
}

function agregarElemento() {
    console.log("ingreso a funcion");
    if(itemIngresado.value.startsWith(" ")) {
        console.log("error");
        avisarError.innerText = "no se puede agregar elemento con espacios";
    }
    else{
        console.log("entro a else");

        const nuevoElemento = document.createElement("li");
        const nuevoBotonEliminar = document.createElement("button");
        nuevoBotonEliminar.style.border = "none";
        nuevoBotonEliminar.style.background = "transparent";
        
        nuevoElemento.textContent = itemIngresado.value;
        nuevoBotonEliminar.innerHTML = '<img id="botonEliminar" src="https://img.icons8.com/?size=100&id=68064&format=png&color=000000" />';
        nuevoElemento.appendChild(nuevoBotonEliminar); 
        lista.appendChild(nuevoElemento);       

        nuevoBotonEliminar.addEventListener("click", () =>  eliminarElemento(nuevoElemento));
    }
}

botonAgregar.addEventListener("click", agregarElemento);