<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pololitos</title>
    <!-- CSS -->
    <link rel="stylesheet" href="/css/home.css">
</head>

            <body>
                <header>
                    <div class="nav-container">
                        <a href="/">
                            <div class="logo">
                                <img src="img/pololitosBlanco.png" alt="Logo pololitos">
                            </div>
                        </a>
                        <nav>
                            <ul class="nav-links">
                                <li><a href="/servicios">Servicios</a></li>
                                <!-- Agregar la opción Mis Servicios solo si el usuario está logueado -->
                                <c:choose>
                                    <c:when test="${not empty sessionScope.usuarioEnSesion}">
                                        <li><a href="/mis-servicios">Mis Servicios</a></li>
                                    </c:when>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${not empty sessionScope.usuarioEnSesion}">
                                        <li><a href="/mis-solicitudes-enviadas">Enviadas</a></li>
                                    </c:when>
                                </c:choose>
                                <c:choose>
                                    <c:when test="${not empty sessionScope.usuarioEnSesion}">
                                        <li><a href="/mis-solicitudes-recibidas">Recibidas</a></li>
                                    </c:when>
                                </c:choose>
                            </ul>
                        </nav>
                    </div>
                    <div class="user-info">
                        

                        
                        <form action="/buscar-servicios" method="get">
                            <div class="circle-busqueda" id="busqueda-container">
                                <input type="text" name="query" id="busqueda-input" placeholder="¿Qué servicio buscas?">
                                <button type="submit" id="busqueda-btn">
                                    <img src="img/busqueda.png" alt="lupa de busqueda" id="busqueda-icon">
                                </button>
                            </div>
                        </form>
                        
                        
                        
                        
                        <c:choose>
                            <c:when test="${not empty sessionScope.usuarioEnSesion}">
                                <a href="/perfilUsuario">
                                    <img src="${sessionScope.usuarioEnSesion.fotoPerfil}" alt="Foto de perfil"
                                        width="40" height="40" style="border-radius: 50%;">
                                </a>
                                <a href="/servicios/publicar"><button>Crear Servicio</button></a>
                                <a href="/logout"><button>Cerrar Sesión</button></a>
                            </c:when>

                            <c:otherwise>
                                <a href="/login"><button>Iniciar sesión</button></a>
                                <a href="/registro"><button>Regístrate</button></a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </header>

                <main>
                    <div class="container">
                        <div class="content">
                            <h1>Publica un Pololo. <br>Genera Ingresos Con Trabajos Pequeños.</h1>
                            <p>Conectamos a personas que buscan ayuda con expertos dispuestos a brindar soluciones</p>
                            <a href="/servicios"><button>Buscar Servicios</button></a>

                        </div>
                    </div>

                    <div class="section" id="empleosRecomendados">
                        <h2>Empleos Recomendados</h2>
                        <c:forEach var="categoria" items="${categorias}">
                            <div class="section categoria" data-count="${fn:length(categoria.servicios)}">
                                <h2>${categoria.nombre}</h2>
                                <div class="cards">
                                    <c:forEach var="servicio" items="${categoria.servicios}">
                                        <div class="card">
                                            <h2>${servicio.nombre}</h2>
                                            <img src="${servicio.imgUrl}" class="card-img-top img-card-profile-service"
                                                alt="${servicio.nombre}">

                                            <p>$${servicio.precio}</p>
                                            <p>${servicio.ciudad}</p>

                                            <!-- Verifica si el usuario está logueado y si es dueño del servicio -->
                                            <c:choose>
                                                <c:when
                                                    test="${empty usuarioSesion or usuarioSesion.id ne servicio.usuario.id}">
                                                    <a href="${pageContext.request.contextPath}/servicio/detalles/${servicio.id}"
                                                        class="btn btn-primary">
                                                        <i class="fas fa-hand-paper"></i> Solicitar Servicio
                                                    </a>
                                                </c:when>

                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/servicio/detalles/${servicio.id}"
                                                        class="btn btn-secondary">
                                                        <i class="fas fa-eye"></i> Ver
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>


                                            <!--   <button class="btn btn-success mt-2" data-bs-toggle="modal"
                                                data-bs-target="#contactModal"
                                                onclick="openModal('${servicio.usuario.nombre}', '${servicio.nombre}')">
                                                <i class="fas fa-comment-alt"></i> Contactar con el Vendedor
                                                
                                            </button> -->
                                        </div>
                                        
                                    </c:forEach>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </main>

                <footer>
                    <p>Pololitos &copy; 2025, Todos los derechos reservados</p>
                    <ul class="nav-footer">
                        <li><a href="/contacto">Contacto</a></li>
                        <li><a href="/nosotros">Nosotros</a></li>
                    </ul>
                </footer>
                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        const categorias = document.querySelectorAll(".categoria");
                        let visibles = 0;

                        categorias.forEach(categoria => {
                            const count = parseInt(categoria.getAttribute("data-count"), 10);
                            if (count === 0 || visibles >= 3) {
                                categoria.style.display = "none"; // Oculta si no tiene servicios o ya hay 2 visibles
                            } else {
                                visibles++;
                            }
                        });
                    });
                </script>
            </body>

            </html>