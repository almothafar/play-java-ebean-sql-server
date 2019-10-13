package models;

import play.data.validation.Constraints;

import javax.persistence.Column;
import javax.persistence.Entity;


/**
 * Company entity managed by Ebean
 */
@Entity
public class Company extends BaseModel {

    private static final long serialVersionUID = 1L;

    @Constraints.Required
    public String name;

    @Column(name = "LocId")
    private Long locationId;

    public Long getLocationId() {
        return locationId;
    }

    public Company setLocationId(Long locationId) {
        this.locationId = locationId;
        return this;
    }
}

