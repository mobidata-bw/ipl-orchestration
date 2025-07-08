<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <NamedLayer>
    <Name>mdbw_sharing_stations_default</Name>
    <UserStyle>
      <Title>MobiData BW® - Sharing-Stationen</Title>
      <FeatureTypeStyle>
        <Rule>
          <Title>Keine Echtzeitdaten</Title>
          <ogc:Filter>
            <ogc:Or>
              <ogc:PropertyIsLike wildCard="*" singleChar="#" escape="!">
                <ogc:PropertyName>feed_id</ogc:PropertyName>
                <ogc:Literal>stadtmobil*</ogc:Literal>
              </ogc:PropertyIsLike>
              <ogc:PropertyIsLike wildCard="*" singleChar="#" escape="!">
                <ogc:PropertyName>feed_id</ogc:PropertyName>
                <ogc:Literal>teilauto*</ogc:Literal>
              </ogc:PropertyIsLike>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>feed_id</ogc:PropertyName>
                <ogc:Literal>oekostadt_renningen</ogc:Literal>
              </ogc:PropertyIsEqualTo>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>feed_id</ogc:PropertyName>
                <ogc:Literal>gruene-flotte_freiburg</ogc:Literal>
              </ogc:PropertyIsEqualTo>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>feed_id</ogc:PropertyName>
                <ogc:Literal>swu2go</ogc:Literal>
              </ogc:PropertyIsEqualTo>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>feed_id</ogc:PropertyName>
                <ogc:Literal>conficars_ulm</ogc:Literal>
              </ogc:PropertyIsEqualTo>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>feed_id</ogc:PropertyName>
                <ogc:Literal>naturenergie_sharing</ogc:Literal>
              </ogc:PropertyIsEqualTo>
            </ogc:Or>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#615fdf</CssParameter>
                </Fill>
                <Stroke>
                  <CssParameter name="stroke">#000000</CssParameter>
                  <CssParameter name="stroke-width">0.5</CssParameter>
                </Stroke>
              </Mark>
              <Size>10</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>
        <Rule>
          <Title>Fahrzeuge verfügbar</Title>  
          <ogc:Filter>     
            <ogc:And>
              <ogc:Not>
                <ogc:Or>
                  <ogc:PropertyIsLike wildCard="*" singleChar="#" escape="!">
                    <ogc:PropertyName>feed_id</ogc:PropertyName>
                    <ogc:Literal>stadtmobil*</ogc:Literal>
                  </ogc:PropertyIsLike>
                  <ogc:PropertyIsLike wildCard="*" singleChar="#" escape="!">
                    <ogc:PropertyName>feed_id</ogc:PropertyName>
                    <ogc:Literal>teilauto*</ogc:Literal>
                  </ogc:PropertyIsLike>
                  <ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>feed_id</ogc:PropertyName>
                    <ogc:Literal>my-e-car</ogc:Literal>
                  </ogc:PropertyIsEqualTo>
                  <ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>feed_id</ogc:PropertyName>
                    <ogc:Literal>oekostadt_renningen</ogc:Literal>
                  </ogc:PropertyIsEqualTo>
                  <ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>feed_id</ogc:PropertyName>
                    <ogc:Literal>gruene_flotte_freiburg</ogc:Literal>
                  </ogc:PropertyIsEqualTo>
                  <ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>feed_id</ogc:PropertyName>
                    <ogc:Literal>swu2go</ogc:Literal>
                  </ogc:PropertyIsEqualTo>
                  <ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>feed_id</ogc:PropertyName>
                    <ogc:Literal>conficars_ulm</ogc:Literal>
                  </ogc:PropertyIsEqualTo>
                  <ogc:PropertyIsEqualTo>
                    <ogc:PropertyName>feed_id</ogc:PropertyName>
                    <ogc:Literal>naturenergie_sharing</ogc:Literal>
                  </ogc:PropertyIsEqualTo>
                </ogc:Or>
              </ogc:Not>   
              <ogc:Or>
                <ogc:PropertyIsGreaterThan>
                  <ogc:PropertyName>num_cars_available</ogc:PropertyName>
                  <ogc:Literal>0</ogc:Literal>
                </ogc:PropertyIsGreaterThan>
                <ogc:PropertyIsGreaterThan>
                  <ogc:PropertyName>num_bicycles_available</ogc:PropertyName>
                  <ogc:Literal>0</ogc:Literal>
                </ogc:PropertyIsGreaterThan>
                <ogc:PropertyIsGreaterThan>
                  <ogc:PropertyName>num_scooters_standing_available</ogc:PropertyName>
                  <ogc:Literal>0</ogc:Literal>
                </ogc:PropertyIsGreaterThan>
                <ogc:PropertyIsGreaterThan>
                  <ogc:PropertyName>num_cargo_bicycles_available</ogc:PropertyName>
                  <ogc:Literal>0</ogc:Literal>
                </ogc:PropertyIsGreaterThan>
                <ogc:PropertyIsGreaterThan>
                  <ogc:PropertyName>num_mopeds_available</ogc:PropertyName>
                  <ogc:Literal>0</ogc:Literal>
                </ogc:PropertyIsGreaterThan>
              </ogc:Or>
            </ogc:And>           
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#fffb05</CssParameter>
                </Fill>
                <Stroke>
                  <CssParameter name="stroke">#000000</CssParameter>
                  <CssParameter name="stroke-width">0.5</CssParameter>
                </Stroke>
              </Mark>
              <Size>10</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>
        <Rule>
          <Title>Keine Fahrzeuge verfügbar</Title>
          <ElseFilter />
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#ffb805</CssParameter>
                </Fill>
                <Stroke>
                  <CssParameter name="stroke">#000000</CssParameter>
                  <CssParameter name="stroke-width">0.5</CssParameter>
                </Stroke>
              </Mark>
              <Size>10</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>