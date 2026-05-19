import { Router } from "express";
import { RoutesApp } from "../../../core/routes";
import { CountryController } from "../../services/controller/country";
import { authenticate, authorize } from "../../middlewares/auth.middleware";

export class CountryRoutes extends RoutesApp {
    public router: Router;
    private controller: CountryController;

    constructor() {
        super();
        this.router = Router();
        this.controller = new CountryController();
        this.setServicesRoutes();
    }

    protected setServicesRoutes(): void {
        this.router.get('/', authenticate, authorize('superadmin'), this.controller.getAll.bind(this.controller));
        this.router.post('/', authenticate, authorize('superadmin'), this.controller.create.bind(this.controller));
        this.router.put('/:id/status', authenticate, authorize('superadmin'), this.controller.updateStatus.bind(this.controller));
        this.router.delete('/:id', authenticate, authorize('superadmin'), this.controller.remove.bind(this.controller));
    }
}