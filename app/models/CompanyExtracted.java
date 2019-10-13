package models;

import io.ebean.annotation.Sql;
import play.data.validation.Constraints;

import javax.persistence.Column;
import javax.persistence.Entity;


/**
 * Company entity managed by Ebean
 */
@Entity
@Sql
public class CompanyExtracted extends BaseModel {

    private static final long serialVersionUID = 1L;

    @Constraints.Required
    public String name;

    @Column(name = "LocId")
    public Long locationId;

    public String locationName;
}

