package com.specure.nt_flutter_standalone.models

import android.os.Parcel
import android.os.Parcelable

class LocationModel(
    val latitude: Double?,
    val longitude: Double?,
    val city: String?,
    val country: String?,
    val county: String?,
    val postalCode: String?
): Parcelable {
    companion object CompanionFactory {
        @JvmField
        val CREATOR = object : Parcelable.Creator<LocationModel> {
            override fun createFromParcel(parcel: Parcel) = LocationModel(parcel)
            override fun newArray(size: Int) = arrayOfNulls<LocationModel>(size)
        }

        @JvmStatic
        fun fromMap(map: Map<String, Any?>): LocationModel {
            return LocationModel(
                map["lat"] as Double?,
                map["long"] as Double?,
                map["city"] as String?,
                map["country"] as String?,
                map["county"] as String?,
                map["postalCode"] as String?,
            )
        }
    }

    private constructor(parcel: Parcel) : this(
        latitude = parcel.readDouble(),
        longitude = parcel.readDouble(),
        city = parcel.readString(),
        country = parcel.readString(),
        county = parcel.readString(),
        postalCode = parcel.readString()
    )

    override fun writeToParcel(parcel: Parcel, flags: Int) {
        parcel.writeDouble(latitude ?: 0.0)
        parcel.writeDouble(longitude ?: 0.0)
        parcel.writeString(city)
        parcel.writeString(country)
        parcel.writeString(county)
        parcel.writeString(postalCode)
    }

    override fun describeContents() = 0
}
