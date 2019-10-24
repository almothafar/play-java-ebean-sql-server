package repository;

import io.ebean.Ebean;
import io.ebean.EbeanServer;
import io.ebean.RawSql;
import io.ebean.RawSqlBuilder;
import models.Company;
import models.CompanyExtracted;
import play.db.ebean.orm.EbeanConfig;

import javax.inject.Inject;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletionStage;

import static java.util.concurrent.CompletableFuture.supplyAsync;

/**
 *
 */
public class CompanyRepository {

    private final EbeanServer ebeanServer;
    private final DatabaseExecutionContext executionContext;

    @Inject
    public CompanyRepository(EbeanConfig ebeanConfig, DatabaseExecutionContext executionContext) {
        this.ebeanServer = Ebean.getServer(ebeanConfig.defaultServer());
        this.executionContext = executionContext;
    }

    public CompletionStage<Map<String, String>> options() {
        return supplyAsync(() -> ebeanServer.find(Company.class).orderBy("name").findList(), executionContext)
                .thenApply(list -> {
                    HashMap<String, String> options = new LinkedHashMap<String, String>();
                    for (Company c : list) {
                        options.put(c.id.toString(), c.name);
                    }
                    return options;
                });
    }

    public CompletionStage<List<Company>> companiesByLocation(long locationId) {
        return supplyAsync(() -> ebeanServer.find(Company.class).where()
                .eq("locationId", locationId)
                .orderBy("name").findList(), executionContext);
    }

    public CompletionStage<List<CompanyExtracted>> companiesByLocationFn(long locationId) {
        final String sql = "SELECT id, name, locationName, locationId FROM fnGetCompanyWithLocation (:id) result";
        return supplyAsync(() -> {
            final RawSql rawSql = RawSqlBuilder.parse(sql).create();
            return Ebean.find(CompanyExtracted.class)
                    .setRawSql(rawSql)
                    .setParameter("id", locationId)
                    .findList();
        }, executionContext);
    }

}
