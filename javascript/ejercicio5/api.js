const linkApi = 'https://wizard-world-api.herokuapp.com/Houses';

document.getElementById('obtenerInfo').addEventListener('click', () => {
  fetch(linkApi)
    .then(response => response.json())
    .then(data => {
        const casa1 = data[0];
        document.querySelector('#c1 .tituloCasa').textContent = casa1.name; 
        document.querySelector('#c1 .infoCasa').textContent = `Fundador: ${casa1.founder}`;

        const listaItems = document.querySelectorAll('#c1 .lista li');
        listaItems[0].textContent = `Animal: ${casa1.animal || 'N/A'}`;
        listaItems[1].textContent = `Colores: ${casa1.houseColours || 'N/A'}`;
        listaItems[2].textContent = `Fundador: ${casa1.founder || 'N/A'}`;


        const casa2 = data[1];
        document.querySelector('#c2 .tituloCasa').textContent = casa2.name; 
        document.querySelector('#c2 .infoCasa').textContent = `Fundador: ${casa2.founder}`;

        const listaItems2 = document.querySelectorAll('#c2 .lista li');
        listaItems2[0].textContent = `Animal: ${casa2.animal || 'N/A'}`;
        listaItems2[1].textContent = `Colores: ${casa2.houseColours || 'N/A'}`;
        listaItems2[2].textContent = `Fundador: ${casa2.founder || 'N/A'}`;

        const casa3 = data[2];
        document.querySelector('#c3 .tituloCasa').textContent = casa3.name;
        document.querySelector('#c3 .infoCasa').textContent = `Fundador: ${casa3.founder}`;

        const listaItems3 = document.querySelectorAll('#c3 .lista li');
        listaItems3[0].textContent = `Animal: ${casa3.animal || 'N/A'}`;
        listaItems3[1].textContent = `Colores: ${casa3.houseColours || 'N/A'}`;
        listaItems3[2].textContent = `Fundador: ${casa3.founder || 'N/A'}`;

        const casa4 = data[3];
        document.querySelector('#c4 .tituloCasa').textContent = casa4.name; 
        document.querySelector('#c4 .infoCasa').textContent = `Fundador: ${casa4.founder}`;

        const listaItems4 = document.querySelectorAll('#c4 .lista li');
        listaItems4[0].textContent = `Animal: ${casa4.animal || 'N/A'}`;
        listaItems4[1].textContent = `Colores: ${casa4.houseColours || 'N/A'}`;
        listaItems4[2].textContent = `Fundador: ${casa4.founder || 'N/A'}`;
    })
    .catch(error => {
      console.error('Error al obtener info:', error); 
    });
});
