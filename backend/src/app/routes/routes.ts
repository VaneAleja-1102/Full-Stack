import { Express } from "express";
import { AuthRoutes } from "./user/user";
import { DashboardRoutes } from "./dashboard/dashboard";
import { CountryRoutes } from "./country/country";
import { SolicitudRoutes } from "./solicitud/solicitud";
import { TestimonioRoutes } from "./testimonio/testimonio";
import { NoticiaRoutes } from "./noticia/noticia";

export class RoutesApi {
    private _app: Express;
    private authRouter: AuthRoutes;
    private dashboardRouter: DashboardRoutes;
    private countryRouter: CountryRoutes;
    private solicitudRouter: SolicitudRoutes;
    private testimonioRouter: TestimonioRoutes;
    private noticiaRouter: NoticiaRoutes;

    constructor(app: Express) {
        this._app = app;
        this.authRouter = new AuthRoutes();
        this.dashboardRouter = new DashboardRoutes();
        this.countryRouter = new CountryRoutes();
        this.solicitudRouter = new SolicitudRoutes();
        this.testimonioRouter = new TestimonioRoutes();
        this.noticiaRouter = new NoticiaRoutes();
        this.initRoutes();
    }

    private initRoutes(): void {
        this._app.use('/api/v1/user', this.authRouter.router);
        this._app.use('/api/v1/dashboard', this.dashboardRouter.router);
        this._app.use('/api/v1/countries', this.countryRouter.router);
        this._app.use('/api/v1/solicitudes', this.solicitudRouter.router);
        this._app.use('/api/v1/testimonios', this.testimonioRouter.router);
        this._app.use('/api/v1/noticias', this.noticiaRouter.router);
    }
}