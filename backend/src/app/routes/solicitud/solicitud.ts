import { Router } from "express";
import { RoutesApp } from "../../../core/routes";
import { SolicitudController } from "../../services/controller/solicitud";
import { authenticate, authorize } from "../../middlewares/auth.middleware";

export class SolicitudRoutes extends RoutesApp {
    public router: Router;
    private controller: SolicitudController;

    constructor() {
        super();
        this.router = Router();
        this.controller = new SolicitudController();
        this.setServicesRoutes();
    }

    protected setServicesRoutes(): void {
        this.router.get('/', authenticate, authorize('superadmin', 'admin_pais', 'editor'), this.controller.getAll.bind(this.controller));
        this.router.get('/:id', authenticate, authorize('superadmin', 'admin_pais', 'editor'), this.controller.getOne.bind(this.controller));
        this.router.post('/', this.controller.create.bind(this.controller)); // público para el formulario de contacto
        this.router.put('/:id/status', authenticate, authorize('superadmin', 'admin_pais', 'editor'), this.controller.updateStatus.bind(this.controller));
        this.router.delete('/:id', authenticate, authorize('superadmin', 'admin_pais'), this.controller.remove.bind(this.controller));
    }
}