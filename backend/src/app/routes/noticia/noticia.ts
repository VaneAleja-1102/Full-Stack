import { Router } from "express";
import { RoutesApp } from "../../../core/routes";
import { NoticiaController } from "../../services/controller/noticia";
import { authenticate, authorize } from "../../middlewares/auth.middleware";

export class NoticiaRoutes extends RoutesApp {
    public router: Router;
    private controller: NoticiaController;

    constructor() {
        super();
        this.router = Router();
        this.controller = new NoticiaController();
        this.setServicesRoutes();
    }

    protected setServicesRoutes(): void {
        this.router.get('/', authenticate, authorize('superadmin', 'admin_pais', 'editor'), this.controller.getAll.bind(this.controller));
        this.router.post('/', authenticate, authorize('superadmin', 'admin_pais', 'editor'), this.controller.create.bind(this.controller));
        this.router.put('/:id', authenticate, authorize('superadmin', 'admin_pais', 'editor'), this.controller.update.bind(this.controller));
        this.router.put('/:id/status', authenticate, authorize('superadmin', 'admin_pais', 'editor'), this.controller.updateStatus.bind(this.controller));
        this.router.delete('/:id', authenticate, authorize('superadmin', 'admin_pais'), this.controller.remove.bind(this.controller));
    }
}