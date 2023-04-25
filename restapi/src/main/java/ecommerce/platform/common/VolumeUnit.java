package ecommerce.platform.common;

public enum VolumeUnit {
    LITER("l"),
    MILLILITER("ml");

    private final String value;

    VolumeUnit(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
