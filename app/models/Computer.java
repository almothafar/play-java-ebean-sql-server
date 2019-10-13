package models;

import io.ebean.annotation.ConstraintMode;
import io.ebean.annotation.DbForeignKey;
import play.data.format.Formats;
import play.data.validation.Constraints;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import java.util.Date;

/**
 * Computer entity managed by Ebean
 */
@Entity 
public class Computer extends BaseModel {

    private static final long serialVersionUID = 1L;

    @Constraints.Required
    public String name;
    
    @Formats.DateTime(pattern="yyyy-MM-dd")
    public Date introduced;
    
    @Formats.DateTime(pattern="yyyy-MM-dd")
    public Date discontinued;

    @ManyToOne(optional = false, cascade = {CascadeType.MERGE, CascadeType.PERSIST, CascadeType.REFRESH})
    @DbForeignKey(onDelete = ConstraintMode.CASCADE)
    public Company company;
    
}

