package com.servicios;

import com.modelos.Notificacion;
import com.modelos.Servicio;
import com.modelos.Solicitud;
import com.modelos.Usuario;
import com.repositorios.RepositorioNotificacionesFirebase;
import org.springframework.stereotype.Service;

import java.time.Instant;

@Service
public class ServicioNotificaciones {

    private final RepositorioNotificacionesFirebase repo;

    public ServicioNotificaciones(RepositorioNotificacionesFirebase repo) {
        this.repo = repo;
    }

    public void notificarNuevaSolicitud(Solicitud solicitud) {
        Usuario solicitante = solicitud.getSolicitante();
        Servicio servicio = solicitud.getServicio();

        String texto = solicitante.getNombre() + " " + solicitante.getApellido() +
                " ha solicitado tu servicio: " + servicio.getNombre();

        Notificacion noti = new Notificacion(
                servicio.getUsuario().getId(), // receptorId
                "Solicitud",
                texto,
                "/mis-solicitudes-recibidas",
                Instant.now().toString(),
                solicitante.getId(),
                solicitante.getNombre() + " " + solicitante.getApellido(),
                servicio.getNombre(),
                servicio.getImgUrl());

        repo.guardarNotificacion(noti);
    }

    public void marcarNotificacionLeida(Long usuarioId, String notificacionId) {
        repo.marcarComoLeida(usuarioId, notificacionId);
    }

    public void notificarCambioEstado(Solicitud solicitud, String nuevoEstado) {
        String mensaje = switch (nuevoEstado) {
            case "Aceptada" -> "Tu solicitud fue aceptada";
            case "Rechazada" -> "Tu solicitud fue rechazada";
            case "Cancelada" -> "El usuario ha cancelado la solicitud";
            case "Completada" -> "El proveedor ha marcado la solicitud como completada";
            default -> "Tu solicitud cambió de estado";
        };
    
        Notificacion noti = Notificacion.crearCambioEstado(solicitud, nuevoEstado, mensaje);
        repo.guardarNotificacion(noti);
    }
    
    

}
