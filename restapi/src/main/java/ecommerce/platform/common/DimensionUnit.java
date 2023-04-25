package ecommerce.platform.common;

public enum DimensionUnit {
    CENTIMETER("cm"),
    MILLIMETER("mm");

    private final String value;

    DimensionUnit(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}